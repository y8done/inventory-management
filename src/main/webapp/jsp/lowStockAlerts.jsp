<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.inventory.model.Product" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Low Stock Alerts</title>
  <link rel="stylesheet" href="../css/styles.css">
</head>
<body>
  <div class="page-shell">
    <header class="page-header">
      <div>
        <p class="eyebrow">Low Stock Monitoring</p>
        <h1>Low Stock Alerts</h1>
      </div>
      <div class="header-meta">
        <a class="btn btn-secondary" href="/dashboard">Back to Dashboard</a>
      </div>
    </header>

    <section class="card table-card">
      <div class="table-header">
        <h2>Low Stock Items</h2>
        <p>Products that are below the recommended reorder threshold.</p>
      </div>
      <table class="table-data">
        <thead>
          <tr>
            <th>Item</th>
            <th>Category</th>
            <th>Qty</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody>
          <% List<Product> lowStock = (List<Product>) request.getAttribute("lowStock");
             if (lowStock != null && !lowStock.isEmpty()) {
               for (Product item : lowStock) {
                 String status = item.getQuantity() <= 5 ? "Low" : "Warning";
          %>
          <tr>
            <td><%= item.getItemName() %></td>
            <td><%= item.getCategory() != null ? item.getCategory() : "—" %></td>
            <td><%= item.getQuantity() %></td>
            <td><span class="status-badge status-badge--warning"><%= status %></span></td>
          </tr>
          <% }
             } else { %>
          <tr>
            <td colspan="4" class="empty-state">No low stock alerts at the moment.</td>
          </tr>
          <% } %>
        </tbody>
      </table>
    </section>
  </div>
</body>
</html>
