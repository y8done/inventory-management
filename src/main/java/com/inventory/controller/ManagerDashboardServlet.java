package com.inventory.controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.inventory.dao.InventoryDAO;
import com.inventory.model.Product;
import com.inventory.model.StockMovement;
import com.inventory.model.User;

@WebServlet("/ManagerDashboardServlet")
public class ManagerDashboardServlet extends HttpServlet{
	protected void doGet(HttpServletRequest req, HttpServletResponse res)
			throws ServletException, IOException
	{
		HttpSession currentSession = req.getSession(false);
		if(currentSession == null)
		{
			res.sendRedirect("Login.jsp");
		    return;
		}
		User activeUser = (User) currentSession.getAttribute("activeUser");
		if (activeUser == null || !activeUser.getRole().equals("MANAGER")) {
		    res.sendRedirect("Login.jsp");
		    return;
		}
		
		InventoryDAO inventoryDAO = new InventoryDAO();
		List<Product> productList = inventoryDAO.getAllProducts();
		List<StockMovement> movements = inventoryDAO.getAllMovements();
		req.setAttribute("inventoryList",productList);
		req.setAttribute("movementList", movements);
		req.getRequestDispatcher("manager-dashboard.jsp").forward(req, res);
	}
}
