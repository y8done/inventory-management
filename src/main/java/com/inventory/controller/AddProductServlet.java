package com.inventory.controller;

import jakarta.servlet.http.HttpServlet;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.inventory.dao.InventoryDAO;
import com.inventory.model.Product;

@WebServlet("/AddProductServlet")
public class AddProductServlet extends HttpServlet{
	protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException
	{
		try{
		String name = req.getParameter("name");
		String category = req.getParameter("category");
		int quantity = Integer.parseInt(req.getParameter("quantity"));
		double price = Double.parseDouble(req.getParameter("price"));
		Date expiryDate = Date.valueOf(req.getParameter("expiryDate"));
		
		Product product = new Product(name,category,quantity,price,expiryDate);
		
		InventoryDAO inventoryDAO = new InventoryDAO();
		boolean success = inventoryDAO.addProduct(product);
		
		if(success)
		{
			res.sendRedirect("ManagerDashboardServlet");
		}else {
			res.getWriter().println("Mission Failed: The database transaction was compromised.");
		}
		}catch(Exception e)
		{
			e.printStackTrace();
            res.getWriter().println("Critical Error: Invalid data parameters intercepted.");
		}
		
		
	}
}
