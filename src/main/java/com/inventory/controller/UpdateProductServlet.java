package com.inventory.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Date;

import com.inventory.dao.InventoryDAO;
import com.inventory.model.Product;

@WebServlet("/UpdateProductServlet")
public class UpdateProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // 1. Intercept the payload
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String category = request.getParameter("category");
            double price = Double.parseDouble(request.getParameter("price"));
            Date expiryDate = Date.valueOf(request.getParameter("expiryDate"));
            
            // 2. Arm the asset object (Quantity is 0 here because it is protected by the Movement Log)
            Product product = new Product();
            product.setId(id);
            product.setName(name);
            product.setCategory(category);
            product.setPrice(price);
            product.setExpiryDate(expiryDate);
            
            // 3. Execute the database strike
            InventoryDAO dao = new InventoryDAO();
            boolean success = dao.updateProduct(product);
            
            // 4. Evaluate and extract
            if (success) {
                // Mission accomplished. Return to the dashboard.
                response.sendRedirect("ManagerDashboardServlet");
            } else {
                response.getWriter().println("Mission Failed: The modification transaction was compromised.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Critical Error: Invalid data parameters intercepted during modification.");
        }
    }
}