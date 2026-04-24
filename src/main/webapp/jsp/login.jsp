<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Inventory System Login</title>
  <link rel="stylesheet" href="../css/styles.css">
</head>
<body>
  <div class="page-shell">
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