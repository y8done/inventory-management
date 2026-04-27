package com.inventory.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.inventory.model.User;
import com.inventory.utils.DBConnection;

public class UserDAO {
	
	public User login(User user) {
		// Start with null. If the query fails, we return null so the Servlet knows login failed.
		User loggedInUser = null; 
		
		String sql = "SELECT * FROM users WHERE username = ? AND password = ? AND is_active = true";
		
		try (Connection con = DBConnection.getConnection();
			 PreparedStatement pstmt = con.prepareStatement(sql)) {
			
			pstmt.setString(1, user.getUsername());
			pstmt.setString(2, user.getPassword());
			
			ResultSet rs = pstmt.executeQuery();
			if (rs.next()) {
				loggedInUser = new User();
				
				loggedInUser.setId(rs.getInt("id"));
				loggedInUser.setFullName(rs.getString("full_name"));
				loggedInUser.setUsername(rs.getString("username"));
				loggedInUser.setRole(rs.getString("role"));
				loggedInUser.setActive(rs.getBoolean("is_active"));
				
			}
			
		} catch (SQLException e) {
			System.out.println("ERROR: Failed to verify user login in database.");
			e.printStackTrace();
		}
		
		return loggedInUser;
	}
	// Fetch all managers
	// Fetch all managers
    public List<Map<String, String>> getAllManagers() {
        List<Map<String, String>> managers = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = 'manager' OR role = 'MANAGER'"; 
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Map<String, String> manager = new HashMap<>();
                manager.put("name", rs.getString("full_name")); 
                manager.put("username", rs.getString("username"));
                manager.put("role", rs.getString("role"));
                manager.put("is_active", String.valueOf(rs.getBoolean("is_active"))); 
                managers.add(manager);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return managers;
    }

    // Insert new manager
    public boolean addManager(String fullName, String username, String password) {
        boolean isSuccess = false;
        // Plain text for now, but lock this down with hashing before deployment
        String sql = "INSERT INTO users (full_name, username, password, role, is_active) VALUES (?, ?, ?, 'MANAGER', TRUE)";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            
            pstmt.setString(1, fullName);
            pstmt.setString(2, username);
            pstmt.setString(3, password); 
            
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                isSuccess = true;
                System.out.println("New manager account secured and activated.");
            }
        } catch (SQLException e) {
            System.out.println("Critical Error: Database rejected the payload.");
            e.printStackTrace();
        }
        return isSuccess;
    }
}