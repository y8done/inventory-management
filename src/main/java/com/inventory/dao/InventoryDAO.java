package com.inventory.dao;


import com.inventory.model.Product;
import com.inventory.model.StockMovement;
import com.inventory.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;


public class InventoryDAO {
	public boolean addProduct(Product product)
	{
		boolean isSuccess = false;
		
		String sql = "INSERT INTO inventory (name, category, quantity, price, expiry_date) VALUES (?, ?, ?, ?, ?)";
		
		try(Connection con = DBConnection.getConnection(); 
				PreparedStatement pstmt = con.prepareStatement(sql))
		{
			pstmt.setString(1, product.getName());
            pstmt.setString(2, product.getCategory());
            pstmt.setInt(3, product.getQuantity());
            pstmt.setDouble(4, product.getPrice());
            pstmt.setDate(5, product.getExpiryDate());
            
            int rowsAffected = pstmt.executeUpdate();
            if(rowsAffected > 0)
            {
            	isSuccess = true;
            }
		}catch (SQLException e) {
            System.out.println("Error adding product to database:");
            e.printStackTrace();
        }
		return isSuccess;
	}
	
	public boolean updateProduct(Product product) {
        boolean isSuccess = false;
        
        // Tactical SQL strike: Update metadata, leave quantity intact
        String sql = "UPDATE inventory SET name = ?, category = ?, price = ?, expiry_date = ? WHERE id = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            
            pstmt.setString(1, product.getName());
            pstmt.setString(2, product.getCategory());
            pstmt.setDouble(3, product.getPrice());
            pstmt.setDate(4, product.getExpiryDate());
            pstmt.setInt(5, product.getId()); // The target identifier
            
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Asset modification successful.");
                isSuccess = true;
            } else {
                System.out.println("Failed to modify asset. Target ID not found.");
            }
        } catch (SQLException e) {
            System.out.println("Critical Error updating inventory asset:");
            e.printStackTrace();
        }
        
        return isSuccess;
    }
	
	public 	List<Product> getAllProducts()
	{
		List<Product> productList = new ArrayList<>();
		String sql = "SELECT * FROM INVENTORY ORDER BY expiry_date ASC";
		
		try(Connection con = DBConnection.getConnection();
				PreparedStatement pstmt = con.prepareStatement(sql);
	             ResultSet rs = pstmt.executeQuery())
		{
			while(rs.next())
			{
				Product product = new Product();
				product.setId(rs.getInt("id"));
				product.setName(rs.getString("name"));
                product.setCategory(rs.getString("category"));
                product.setQuantity(rs.getInt("quantity"));
                product.setPrice(rs.getDouble("price"));
                product.setExpiryDate(rs.getDate("expiry_date"));
                
                productList.add(product);
			}
		}catch (SQLException e) {
            System.out.println("Error fetching products from database:");
            e.printStackTrace();
        }
		return productList;
	}
	
    public static void main(String[] args) {
        InventoryDAO dao = new InventoryDAO();

        System.out.println("--- 1. Testing Database Insert ---");

        java.sql.Date dummyExpiry = java.sql.Date.valueOf("2026-05-15"); 
       
        Product testProduct = new Product("Paracetamol 500mg", "Medicine", 50, 12.99, dummyExpiry);
        
        boolean success = dao.addProduct(testProduct);
        if (success) {
            System.out.println("SUCCESS: Paracetamol was saved to Neon!");
        } else {
            System.out.println("FAIL: Could not save to database.");
        }

        System.out.println("\n--- 2. Testing Database Select ---");
        // Try to fetch all items
        List<Product> list = dao.getAllProducts();
        if (list.isEmpty()) {
            System.out.println("The inventory is empty.");
        } else {
            for (Product p : list) {
                System.out.println("Found Item -> ID: " + p.getId() + 
                                   " | Name: " + p.getName() + 
                                   " | Qty: " + p.getQuantity() + 
                                   " | Expiry: " + p.getExpiryDate());
            }
        }
    }
    
    
    public boolean recordMovement(StockMovement movement)
    {
    	boolean isSuccess = false;
    	Connection con = null;
    	
    	
    	try
    	{
    		con = DBConnection.getConnection();
    		con.setAutoCommit(false);
    		
    		
    		
    		String sql ="UPDATE inventory SET quantity = quantity + ? WHERE id = ?";
			try(PreparedStatement pstmt = con.prepareStatement(sql))
			{
				if(movement.getMovementType().equals("IN")) {
	    			pstmt.setInt(1, movement.getQuantity());
	    		}else {
	    			pstmt.setInt(1,movement.getQuantity()-(movement.getQuantity()*2));
	    		}
	    		pstmt.setInt(2, movement.getProductId());
	    		
	    		int updatedRows = pstmt.executeUpdate();
	    		if(updatedRows > 0)
	    		{
	    			System.out.println("Stock updated successfully!");
	    		}else {
	    			System.out.println("Error updating the stock");
	    		}
			}
			
			String insertSql = "INSERT INTO stock_movements (product_id, movement_type, quantity, movement_date, remarks) VALUES (?, ?, ?, ?, ?)";
			try(PreparedStatement pstmt = con.prepareStatement(insertSql))
			{
				pstmt.setInt(1, movement.getProductId());
				pstmt.setString(2, movement.getMovementType());
				pstmt.setInt(3, movement.getQuantity());
				pstmt.setDate(4, movement.getMovementDate());
				pstmt.setString(5, movement.getRemarks());
	    		
	    		int updatedRows = pstmt.executeUpdate();
	    		if(updatedRows > 0)
	    		{
	    			System.out.println("Stock updated successfully!");
	    		}else {
	    			System.out.println("Error updating the stock");
	    		}
			}
			con.commit();
	        isSuccess = true;
	        System.out.println("Transaction successful: Stock updated and movement logged.");
	        
	    } catch (SQLException e) {
	        if (con != null) {
	            try { 
	                con.rollback(); 
	                System.out.println("Transaction failed. Changes rolled back.");
	            } catch (SQLException ex) { 
	                ex.printStackTrace(); 
	            }
	        }
	        e.printStackTrace();
	    } finally {
	        // 4. CLEAN UP
	        if (con != null) {
	            try { con.close(); } catch (SQLException ex) { ex.printStackTrace(); }
	        }
	    }
    	return isSuccess;
    }
    
    public List<StockMovement> getAllMovements(){
    	List<StockMovement> movements = new ArrayList<>();
    	
    	String sql = "SELECT \n"
    			+ "    m.id, \n"
    			+ "    m.product_id, \n"
    			+ "    i.name AS product_name, \n"
    			+ "    m.movement_type, \n"
    			+ "    m.quantity, \n"
    			+ "    m.movement_date, \n"
    			+ "    m.remarks\n"
    			+ "FROM \n"
    			+ "    stock_movements m\n"
    			+ "INNER JOIN \n"
    			+ "    inventory i ON m.product_id = i.id\n"
    			+ "ORDER BY \n"
    			+ "    m.movement_date DESC;";
    	try(Connection con = DBConnection.getConnection();
    			PreparedStatement pstmt = con.prepareStatement(sql))
    	{
    		ResultSet rs = pstmt.executeQuery();
    		
    		while(rs.next()) {
    		    StockMovement sm = new StockMovement();
    		    
    		    
    		    sm.setMovementId(rs.getInt("id"));
    		    sm.setProductId(rs.getInt("product_id"));
    		    sm.setProductName(rs.getString("product_name")); 
    		    sm.setMovementType(rs.getString("movement_type"));
    		    sm.setQuantity(rs.getInt("quantity"));
    		    sm.setMovementDate(rs.getDate("movement_date"));
    		    sm.setRemarks(rs.getString("remarks"));
    		    
    		    
    		    movements.add(sm);
    		}
    		
    	} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	return movements;
    }
    
    
};