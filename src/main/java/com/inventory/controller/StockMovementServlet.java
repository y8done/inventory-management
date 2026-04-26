package com.inventory.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Date;

import com.inventory.dao.InventoryDAO;
import com.inventory.model.StockMovement;

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

            int productId = Integer.parseInt(productIdStr);
            int quantity = Integer.parseInt(quantityStr);
            Date movementDate = Date.valueOf(dateStr); 

            StockMovement movement = new StockMovement(0, productId, null, movementType, quantity, movementDate, remarks);

            InventoryDAO dao = new InventoryDAO();
            boolean success = dao.recordMovement(movement);


            if (success) {
              
                response.sendRedirect("ManagerDashboardServlet");
            } else {
      
                response.getWriter().println("Mission Failed: The database transaction was compromised.");
            }

        } catch (Exception e) {

            e.printStackTrace();
            response.getWriter().println("Critical Error: Invalid data parameters intercepted.");
        }
    }
}