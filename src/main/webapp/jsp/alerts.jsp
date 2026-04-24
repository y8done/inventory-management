<%@ page import="java.util.*, com.inventory.model.Product" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Expiry Alerts</title>
  <link rel="stylesheet" href="../css/styles.css">
</head>
<body>
  <div class="page-shell">
    <header class="page-header">
      <div>
        <p class="eyebrow">Expiry Monitoring</p>
        <h1>Expiry Alerts</h1>
      </div>
      <div class="header-meta">
        <a class="btn btn-secondary" href="/dashboard">Back to Dashboard</a>
      </div>
    </header>

    <section class="grid grid--cards">
      <div class="card card-status card-status--danger">
        <h2>Expired Items</h2>
        <div class="card-body">
          <ul>
            <% List<Product> expired = (List<Product>) request.getAttribute("expired");
               if (expired != null && !expired.isEmpty()) {
                 for (Product p : expired) { %>
                   <li><strong><%= p.getItemName() %></strong> — <%= p.getQuantity() %> units</li>
                 <% }
               } else { %>
                 <li class="muted">No expired items found.</li>
               <% } %>
          </ul>
        </div>
      </div>

      <div class="card card-status card-status--warning">
        <h2>Expiring Soon</h2>
        <div class="card-body">
          <ul>
            <% List<Product> warning = (List<Product>) request.getAttribute("warning");
               if (warning != null && !warning.isEmpty()) {
                 for (Product p : warning) { %>
                   <li><strong><%= p.getItemName() %></strong> — expiring <%= p.getExpiryDate() %></li>
                 <% }
               } else { %>
                 <li class="muted">No items expiring within the next few days.</li>
               <% } %>
          </ul>
        </div>
      </div>
    </section>
  </div>
</body>
</html>