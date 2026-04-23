package com.inventory.dao;


import com.inventory.model.Product;
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
		
		String sql = "INSERT INTO inventory (item_name, category, quantity, price, expiry_date) VALUES (?, ?, ?, ?, ?)";
		
		try(Connection con = DBConnection.getConnection(); 
				PreparedStatement pstmt = con.prepareStatement(sql))
		{
			pstmt.setString(1, product.getItemName());
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
                product.setItemId(rs.getInt("item_id"));
                product.setItemName(rs.getString("item_name"));
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
                System.out.println("Found Item -> ID: " + p.getItemId() + 
                                   " | Name: " + p.getItemName() + 
                                   " | Qty: " + p.getQuantity() + 
                                   " | Expiry: " + p.getExpiryDate());
            }
        }
    }
};