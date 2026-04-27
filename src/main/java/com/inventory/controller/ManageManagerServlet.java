package com.inventory.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.inventory.dao.UserDAO;

@WebServlet("/ManageManagerServlet")
public class ManageManagerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // 1. Intercept the schema-accurate payload
            String fullName = request.getParameter("fullName");
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            
            // 2. Validate
            if (fullName == null || username == null || password == null || fullName.trim().isEmpty()) {
                response.getWriter().println("Mission Failed: Missing required credentials.");
                return;
            }
            
            // 3. Execute database strike
            UserDAO userDAO = new UserDAO();
            boolean success = userDAO.addManager(fullName, username, password);
            
            // 4. Extract
            if (success) {
                response.sendRedirect("AdminDashboardServlet");
            } else {
                response.getWriter().println("Mission Failed: The database transaction was compromised. Username may already exist.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Critical Error: Invalid data parameters intercepted.");
        }
    }
}