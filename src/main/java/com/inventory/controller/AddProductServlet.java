package com.inventory.controller;

import java.io.IOException;
import java.sql.Date;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.inventory.dao.InventoryDAO;
import com.inventory.model.Product;

@WebServlet("/AddProductServlet")
public class AddProductServlet extends HttpServlet{
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // 1. Intercept standard payloads
            String name = request.getParameter("name");
            String category = request.getParameter("category");
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            double price = Double.parseDouble(request.getParameter("price"));
            
            // 2. Safely Intercept and Parse the Date
            String expiryStr = request.getParameter("expiryDate");
            Date expiryDate = null;
            
            if (expiryStr == null || expiryStr.trim().isEmpty()) {
                response.getWriter().println("Mission Failed: An Expiry Date is strictly required to register a new asset batch.");
                return; // Halt execution before crash
            }
            
            try {
                expiryDate = Date.valueOf(expiryStr);
            } catch (IllegalArgumentException e) {
                response.getWriter().println("Mission Failed: The date format was corrupted. System requires YYYY-MM-DD.");
                return; // Halt execution before crash
            }
            
            // 3. Arm the asset object
            Product product = new Product();
            product.setName(name);
            product.setCategory(category);
            product.setQuantity(quantity);
            product.setPrice(price);
            product.setExpiryDate(expiryDate);
            
            // 4. Execute database strike
            InventoryDAO inventoryDAO = new InventoryDAO();
            boolean success = inventoryDAO.addProduct(product);
            
            // 5. Route back
            if(success) {
                response.sendRedirect("ManagerDashboardServlet");
            } else {
                response.getWriter().println("Mission Failed: The database transaction was compromised.");
            }
            
        } catch(NumberFormatException e) {
            e.printStackTrace();
            response.getWriter().println("Critical Error: Quantity and Price must be valid numbers.");
        } catch(Exception e) {
            e.printStackTrace();
            response.getWriter().println("Critical Error: Invalid data parameters intercepted.");
        }
    }
}