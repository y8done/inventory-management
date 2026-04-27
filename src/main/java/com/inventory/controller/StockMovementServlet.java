package com.inventory.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;

import com.inventory.dao.InventoryDAO;
import com.inventory.model.StockMovement;
import com.inventory.model.User; 

@WebServlet("/StockMovementServlet")
public class StockMovementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
    	try {
            String productIdStr = request.getParameter("productId");
            String movementType = request.getParameter("movementType");
            String quantityStr = request.getParameter("quantity");
            String dateStr = request.getParameter("movementDate");
            String remarks = request.getParameter("remarks");
            
            // NEW: Extract the Batch Expiry Date (Only used for 'IN' movements)
            String batchExpiryStr = request.getParameter("batchExpiryDate");
            Date batchExpiryDate = null;
            if (batchExpiryStr != null && !batchExpiryStr.trim().isEmpty()) {
                batchExpiryDate = Date.valueOf(batchExpiryStr);
            }

            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("activeUser");
            String managerUsername = (currentUser != null) ? currentUser.getUsername() : "SYSTEM";

            int productId = Integer.parseInt(productIdStr);
            int quantity = Integer.parseInt(quantityStr);
            Date movementDate = Date.valueOf(dateStr); 

            StockMovement movement = new StockMovement(0, productId, null, movementType, quantity, movementDate, remarks, managerUsername);

            InventoryDAO dao = new InventoryDAO();
            // NEW: Pass BOTH parameters to the DAO
            boolean success = dao.recordMovement(movement, batchExpiryDate);

            if (success) {
                response.sendRedirect("ManagerDashboardServlet");
            } else {
                response.getWriter().println("Mission Failed: The database transaction was compromised. Insufficient stock or invalid batch.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Critical Error: Invalid data parameters intercepted.");
        }
    }
}