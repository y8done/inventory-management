package com.inventory.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ResourceBundle;

public class DBConnection {
	private static ResourceBundle rb = ResourceBundle.getBundle("db");
	
	private static final String URL = rb.getString("db.url");
    private static final String USER = rb.getString("db.user");
    private static final String PASSWORD = rb.getString("db.password");
	
	public static Connection getConnection() {
		Connection connection = null;
		
		try {
			Class.forName("org.postgresql.Driver");
			
			connection = DriverManager.getConnection(URL,USER,PASSWORD);
			System.out.println("Database Connected susccessfully !!");
			
			
		}catch(ClassNotFoundException e)
		{
			System.out.println("ERROR: PostgreSQL Driver not found. Did you add the .jar file?");
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("ERROR: Failed to connect to the database. Check your URL/Password.");
            e.printStackTrace();
		}
		return connection;
	}
	
	public static void main(String args[])
	{
		Connection testcon = DBConnection.getConnection();
		if(testcon != null)
		{
			System.out.println("You are ready !!!!!");
		}
	}
}
