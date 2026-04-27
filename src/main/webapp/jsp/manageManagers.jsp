<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Manage Managers</title>
  <link rel="stylesheet" href="../css/styles.css">
</head>
<body>
  <div class="page-shell">
    <header class="page-header">
      <div>
        <p class="eyebrow">Manager Accounts</p>
        <h1>Manage Managers</h1>
      </div>
      <div class="header-meta">
        <a class="btn btn-secondary" href="/dashboard">Back to Dashboard</a>
      </div>
    </header>

    <section class="card table-card">
      <div class="table-header">
        <h2>Manager Accounts</h2>
        <p>Review current managers and ensure access is up to date.</p>
      </div>
      <table class="table-data">
        <thead>
          <tr>
            <th>Name</th>
            <th>Email</th>
            <th>Role</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody>
          <% List<Map<String, String>> managers = (List<Map<String, String>>) request.getAttribute("managers");
             if (managers != null && !managers.isEmpty()) {
               for (Map<String, String> manager : managers) {
          %>
          <tr>
            <td><%= manager.get("name") %></td>
            <td><%= manager.get("email") %></td>
            <td><%= manager.get("role") != null ? manager.get("role") : "Manager" %></td>
            <td><span class="status-badge status-badge--normal"><%= manager.get("status") != null ? manager.get("status") : "Active" %></span></td>
          </tr>
          <% }
             } else { %>
          <tr>
            <td colspan="4" class="empty-state">No manager accounts found. Add a new manager below.</td>
          </tr>
          <% } %>
        </tbody>
      </table>
    </section>

    <section class="card form-card">
      <div class="form-header">
        <h2>Create New Manager</h2>
        <p>Add a new manager account for inventory access.</p>
      </div>
      <form action="ManageManagerServlet" method="post" class="form-grid">
        <label>
          Full Name
          <input type="text" name="name" placeholder="Manager full name" required>
        </label>
        <label>
          Email
          <input type="email" name="email" placeholder="Manager email" required>
        </label>
        <label>
          Username
          <input type="text" name="username" placeholder="Login username" required>
        </label>
        <label>
          Password
          <input type="password" name="password" placeholder="Temporary password" required>
        </label>
        <div class="form-actions">
          <button type="submit" class="btn btn-primary">Create Manager</button>
        </div>
      </form>
    </section>
  </div>
</body>
</html>
