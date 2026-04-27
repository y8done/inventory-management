<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.inventory.model.Product" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Expired Items</title>
  <link rel="stylesheet" href="../css/styles.css">
</head>
<body>
  <div class="page-shell">
    <header class="page-header">
      <div>
        <p class="eyebrow">Expired Inventory</p>
        <h1>Expired Items</h1>
      </div>
      <div class="header-meta">
        <a class="btn btn-secondary" href="/dashboard">Back to Dashboard</a>
      </div>
    </header>

    <section class="card table-card">
      <div class="table-header">
        <h2>Expired Stock</h2>
        <p>All products that are past their expiration date.</p>
      </div>
      <table class="table-data">
        <thead>
          <tr>
            <th>Item</th>
            <th>Category</th>
            <th>Qty</th>
            <th>Expiry Date</th>
          </tr>
        </thead>
        <tbody>
          <% List<Product> expired = (List<Product>) request.getAttribute("expired");
             if (expired != null && !expired.isEmpty()) {
               for (Product item : expired) {
          %>
          <tr>
            <td><%= item.getItemName() %></td>
            <td><%= item.getCategory() != null ? item.getCategory() : "—" %></td>
            <td><%= item.getQuantity() %></td>
            <td><%= item.getExpiryDate() != null ? item.getExpiryDate() : "N/A" %></td>
          </tr>
          <% }
             } else { %>
          <tr>
            <td colspan="4" class="empty-state">No expired items found.</td>
          </tr>
          <% } %>
        </tbody>
      </table>
    </section>
  </div>
</body>
</html>
