<%@ page import="java.util.*, com.inventory.model.Product" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Inventory List</title>
  <link rel="stylesheet" href="../css/styles.css">
</head>
<body>
  <div class="page-shell">
    <header class="page-header">
      <div>
        <p class="eyebrow">Inventory Overview</p>
        <h1>Current Stock</h1>
      </div>
      <div class="header-meta">
        <a class="btn btn-secondary" href="/dashboard">Back to Dashboard</a>
      </div>
    </header>

    <%
      List<Product> items = (List<Product>) request.getAttribute("items");
      java.sql.Date today = new java.sql.Date(System.currentTimeMillis());
    %>

    <section class="card table-card">
      <div class="table-header">
        <h2>Inventory Details</h2>
        <p class="muted">Showing all captured inventory records.</p>
      </div>
      <table class="table-data">
        <thead>
          <tr>
            <th>Item</th>
            <th>Category</th>
            <th>Qty</th>
            <th>Expiry</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody>
          <% if (items != null && !items.isEmpty()) {
               for (Product item : items) {
                 java.sql.Date expiry = item.getExpiryDate();
                 String status = "normal";
                 if (expiry != null) {
                   long diff = expiry.getTime() - today.getTime();
                   if (expiry.before(today)) {
                     status = "expired";
                   } else if (diff <= 7L * 24 * 60 * 60 * 1000) {
                     status = "warning";
                   }
                 }
          %>
          <tr>
            <td><%= item.getItemName() %></td>
            <td><%= item.getCategory() != null ? item.getCategory() : "—" %></td>
            <td><%= item.getQuantity() %></td>
            <td><%= item.getExpiryDate() != null ? item.getExpiryDate() : "N/A" %></td>
            <td><span class="status-badge status-badge--<%= status %>"><%= status.equals("expired") ? "Expired" : status.equals("warning") ? "Expiring Soon" : "Good" %></span></td>
          </tr>
          <%   }
             } else { %>
          <tr>
            <td colspan="5" class="empty-state">No inventory records found.</td>
          </tr>
          <% } %>
        </tbody>
      </table>
    </section>
  </div>
</body>
</html>