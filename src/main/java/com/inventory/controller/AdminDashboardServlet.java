package com.inventory.controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.inventory.dao.InventoryDAO;
import com.inventory.dao.UserDAO;
import com.inventory.model.Product;
import com.inventory.model.StockMovement;

@WebServlet("/AdminDashboardServlet")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        InventoryDAO inventoryDAO = new InventoryDAO();
        UserDAO userDAO = new UserDAO();
        
        // 1. Extract Intel from Database
        List<Product> expiredList = inventoryDAO.getExpiredProducts();
        List<Product> lowStockList = inventoryDAO.getLowStockProducts(10); // 10 is the warning threshold
        List<Map<String, String>> managerList = userDAO.getAllManagers();
        
        // 2. Calculate Dashboard Metrics
        int expiredCount = expiredList.size();
        int lowStockCount = lowStockList.size();
        int alertCount = expiredCount + lowStockCount;
        int managerCount = managerList.size();
        
        // 3. Attach Payloads to the Request
        request.setAttribute("expired", expiredList);
        request.setAttribute("lowStock", lowStockList);
        request.setAttribute("managers", managerList);
        
        request.setAttribute("expiredCount", expiredCount);
        request.setAttribute("lowStockCount", lowStockCount);
        request.setAttribute("alertCount", alertCount);
        request.setAttribute("managerCount", managerCount);
     // Extract Audit Logs
        List<StockMovement> auditLogs = inventoryDAO.getAllMovements();
        request.setAttribute("auditLogs", auditLogs);
        
        // 4. Dispatch to the UI
        request.getRequestDispatcher("admin-dashboard.jsp").forward(request, response);
    }
}