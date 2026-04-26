package com.inventory.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

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
}