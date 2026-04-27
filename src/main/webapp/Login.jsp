<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.inventory.model.User" %>
<%@ page import="com.inventory.model.User" %>
<%
    // 1. CACHE-KILLING PROTOCOL: Force the browser to never save this page
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0
    response.setDateHeader("Expires", 0); // Proxies

    // 2. SECURITY INTERCEPT: Bounce logged-in users back to their dashboard
    User activeUser = (User) session.getAttribute("activeUser");
    if (activeUser != null) {
        if ("ADMIN".equalsIgnoreCase(activeUser.getRole())) {
            response.sendRedirect("AdminDashboardServlet");
        } else {
            response.sendRedirect("ManagerDashboardServlet");
        }
        return; // Halt execution
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Inventory System Login</title>
  <link rel="stylesheet" href="css/styles.css">
</head>
<body>
  <div class="auth-wrapper">
    <section class="card auth-card">
      <div class="form-header">
        <h1>Inventory System Login</h1>
        <p>Access manager and admin operations.</p>
      </div>
      <% String error = (String) request.getAttribute("error"); if (error != null) { %>
      <div class="alert alert-error"><%= error %></div>
      <% } %>
      <form action="LoginServlet" method="post" class="form-grid">
        <label>
          Username
          <input type="text" name="username" placeholder="Enter username" required>
        </label>
        <label>
          Password
          <input type="password" name="password" placeholder="Enter password" required>
        </label>
        <label>
          Role
          <select name="role" required>
            <option value="manager">Manager</option>
            <option value="admin">Admin</option>
          </select>
        </label>
        <div class="form-actions">
          <button type="submit" class="btn btn-primary">Sign In</button>
        </div>
      </form>
    </section>
  </div>
</body>
</html>