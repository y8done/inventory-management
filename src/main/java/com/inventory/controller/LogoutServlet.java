package com.inventory.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Fetch the current session (false means don't create a new one if it doesn't exist)
        HttpSession session = request.getSession(false);
        
        // 2. Terminate the session
        if (session != null) {
            session.invalidate(); 
            System.out.println("Session terminated. User logged out.");
        }
        
        // 3. Reroute to the perimeter
        response.sendRedirect("Login.jsp");
    }
}