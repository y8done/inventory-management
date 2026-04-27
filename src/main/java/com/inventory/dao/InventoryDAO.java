package com.inventory.dao;


import com.inventory.model.Product;
import com.inventory.model.StockMovement;
import com.inventory.utils.DBConnection;

import java.sql.Statement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;


public class InventoryDAO {
	public boolean addProduct(Product product) {
        // We use a transaction because we write to two tables
        String sqlMaster = "INSERT INTO inventory (name, category, price) VALUES (?, ?, ?)";
        String sqlBatch = "INSERT INTO product_batches (product_id, quantity, expiry_date) VALUES (?, ?, ?)";
        
        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false); // Start Transaction
            
            try (PreparedStatement pstmtMaster = con.prepareStatement(sqlMaster, Statement.RETURN_GENERATED_KEYS)) {
                pstmtMaster.setString(1, product.getName());
                pstmtMaster.setString(2, product.getCategory());
                pstmtMaster.setDouble(3, product.getPrice());
                pstmtMaster.executeUpdate();
                
                // Extract the new Auto-Incremented ID
                ResultSet rs = pstmtMaster.getGeneratedKeys();
                int newProductId = 0;
                if (rs.next()) { newProductId = rs.getInt(1); }
                
                // Insert the first batch
                try (PreparedStatement pstmtBatch = con.prepareStatement(sqlBatch)) {
                    pstmtBatch.setInt(1, newProductId);
                    pstmtBatch.setInt(2, product.getQuantity());
                    pstmtBatch.setDate(3, product.getExpiryDate());
                    pstmtBatch.executeUpdate();
                }
                
                con.commit(); // Save both tables
                return true;
            } catch (SQLException e) {
                con.rollback(); // If one fails, undo both
                e.printStackTrace();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
	
	public boolean updateProduct(Product product) {
        // Note: Expiry Date and Quantity are NOT updated here. They are controlled by movements.
        String sql = "UPDATE inventory SET name = ?, category = ?, price = ? WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            
            pstmt.setString(1, product.getName());
            pstmt.setString(2, product.getCategory());
            pstmt.setDouble(3, product.getPrice());
            pstmt.setInt(4, product.getId());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
	
	public List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();
        // Tactical JOIN: Sums the quantity of all batches, and finds the earliest expiry date
        String sql = "SELECT i.id, i.name, i.category, i.price, " +
                     "COALESCE(SUM(b.quantity), 0) AS total_quantity, " +
                     "MIN(b.expiry_date) AS earliest_expiry " +
                     "FROM inventory i " +
                     "LEFT JOIN product_batches b ON i.id = b.product_id " +
                     "GROUP BY i.id, i.name, i.category, i.price " +
                     "ORDER BY i.name ASC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setCategory(rs.getString("category"));
                p.setPrice(rs.getDouble("price"));
                p.setQuantity(rs.getInt("total_quantity"));
                p.setExpiryDate(rs.getDate("earliest_expiry"));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
	

    
    
    public boolean recordMovement(StockMovement movement, Date newBatchExpiry) {
        String sqlInsertLog = "INSERT INTO stock_movements (product_id, movement_type, quantity, movement_date, remarks, manager_username) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false); // Start Transaction
            
            // 1. Log the movement in the audit trail
            try (PreparedStatement pstmtLog = con.prepareStatement(sqlInsertLog)) {
                pstmtLog.setInt(1, movement.getProductId());
                pstmtLog.setString(2, movement.getMovementType());
                pstmtLog.setInt(3, movement.getQuantity());
                pstmtLog.setDate(4, movement.getMovementDate());
                pstmtLog.setString(5, movement.getRemarks());
                pstmtLog.setString(6, movement.getManagerUsername());
                pstmtLog.executeUpdate();
            }

            // 2. Process IN (Create New Batch)
            if ("IN".equalsIgnoreCase(movement.getMovementType())) {
                String sqlIn = "INSERT INTO product_batches (product_id, quantity, expiry_date) VALUES (?, ?, ?)";
                try (PreparedStatement pstmtIn = con.prepareStatement(sqlIn)) {
                    pstmtIn.setInt(1, movement.getProductId());
                    pstmtIn.setInt(2, movement.getQuantity());
                    pstmtIn.setDate(3, newBatchExpiry); // The new date from the UI
                    pstmtIn.executeUpdate();
                }
            } 
            // 3. Process OUT (The FEFO Engine)
            else if ("OUT".equalsIgnoreCase(movement.getMovementType())) {
                int quantityNeeded = movement.getQuantity();
                
                // Fetch all batches for this product, ordered by expiry date (oldest first)
                String sqlFetchBatches = "SELECT batch_id, quantity FROM product_batches WHERE product_id = ? AND quantity > 0 ORDER BY expiry_date ASC FOR UPDATE";
                
                try (PreparedStatement pstmtFetch = con.prepareStatement(sqlFetchBatches)) {
                    pstmtFetch.setInt(1, movement.getProductId());
                    ResultSet rs = pstmtFetch.executeQuery();
                    
                    String sqlUpdateBatch = "UPDATE product_batches SET quantity = ? WHERE batch_id = ?";
                    try (PreparedStatement pstmtUpdate = con.prepareStatement(sqlUpdateBatch)) {
                        
                        while (rs.next() && quantityNeeded > 0) {
                            int batchId = rs.getInt("batch_id");
                            int batchQty = rs.getInt("quantity");
                            
                            if (batchQty <= quantityNeeded) {
                                // Take the whole batch
                                pstmtUpdate.setInt(1, 0); // Batch is empty
                                pstmtUpdate.setInt(2, batchId);
                                pstmtUpdate.executeUpdate();
                                quantityNeeded -= batchQty;
                            } else {
                                // Take a partial batch
                                pstmtUpdate.setInt(1, batchQty - quantityNeeded);
                                pstmtUpdate.setInt(2, batchId);
                                pstmtUpdate.executeUpdate();
                                quantityNeeded = 0; // Request fulfilled
                            }
                        }
                    }
                    
                    // Fail-safe: If we ran out of batches before fulfilling the request
                    if (quantityNeeded > 0) {
                        System.out.println("CRITICAL FAILURE: Attempted to withdraw more stock than exists.");
                        con.rollback();
                        return false;
                    }
                }
            }

            con.commit(); // Secure all changes
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            return false; // Auto-rolls back on connection close
        }
    }
    
    public List<StockMovement> getAllMovements() {
        List<StockMovement> list = new ArrayList<>();
        String sql = "SELECT s.*, i.name AS product_name " +
                     "FROM stock_movements s " +
                     "JOIN inventory i ON s.product_id = i.id " +
                     "ORDER BY s.movement_date DESC";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                StockMovement sm = new StockMovement();
                
                // THE FIX IS HERE: Changed "id" to "movement_id"
                sm.setMovementId(rs.getInt("movement_id")); 
                
                sm.setProductId(rs.getInt("product_id"));
                sm.setProductName(rs.getString("product_name"));
                sm.setMovementType(rs.getString("movement_type"));
                sm.setQuantity(rs.getInt("quantity"));
                sm.setMovementDate(rs.getDate("movement_date"));
                sm.setRemarks(rs.getString("remarks"));
                sm.setManagerUsername(rs.getString("manager_username")); 
                
                list.add(sm);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    public List<Product> getExpiredProducts() {
        List<Product> list = new ArrayList<>();
        // Tactical JOIN: Finds specific batches that are expired and still have physical stock
        String sql = "SELECT i.id, i.name, i.category, b.quantity, b.expiry_date " +
                     "FROM inventory i " +
                     "JOIN product_batches b ON i.id = b.product_id " +
                     "WHERE b.expiry_date < CURRENT_DATE AND b.quantity > 0 " +
                     "ORDER BY b.expiry_date ASC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setCategory(rs.getString("category"));
                p.setQuantity(rs.getInt("quantity")); // Quantity of the specific expired batch
                p.setExpiryDate(rs.getDate("expiry_date"));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Fetch items below a specific stock threshold
    public List<Product> getLowStockProducts(int threshold) {
        List<Product> list = new ArrayList<>();
        // Tactical SUM & HAVING: Groups all batches together and checks if the total is dangerously low
        String sql = "SELECT i.id, i.name, i.category, " +
                     "COALESCE(SUM(b.quantity), 0) AS total_quantity " +
                     "FROM inventory i " +
                     "LEFT JOIN product_batches b ON i.id = b.product_id " +
                     "GROUP BY i.id, i.name, i.category " +
                     "HAVING COALESCE(SUM(b.quantity), 0) <= ? " +
                     "ORDER BY total_quantity ASC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            
            pstmt.setInt(1, threshold);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setId(rs.getInt("id"));
                    p.setName(rs.getString("name"));
                    p.setCategory(rs.getString("category"));
                    p.setQuantity(rs.getInt("total_quantity")); // Total across all batches
                    // Expiry date is irrelevant for a low-stock alert across multiple batches
                    list.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
};