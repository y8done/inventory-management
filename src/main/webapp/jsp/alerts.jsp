<%@ page import="java.util.*, com.inventory.model.Product" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Alerts Center</title>
  <link rel="stylesheet" href="../css/styles.css">
</head>
<body>
  <div class="page-shell">
    <header class="page-header">
      <div>
        <p class="eyebrow">Alerts Center</p>
        <h1>Inventory Alerts</h1>
      </div>
      <div class="header-meta">
        <a class="btn btn-secondary" href="/dashboard">Back to Dashboard</a>
      </div>
    </header>

    <section class="grid grid--cards">
      <a class="card card-link" href="/expiredItems">
        <h2>Expired Items</h2>
        <p>View all inventory records that are past their expiry date.</p>
      </a>
      <a class="card card-link" href="/lowStock">
        <h2>Low Stock Alerts</h2>
        <p>See products that need restocking soon.</p>
      </a>
    </section>
  </div>
</body>
</html>