<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Reports</title>
  <link rel="stylesheet" href="../css/styles.css">
</head>
<body>
  <div class="page-shell">
    <header class="page-header">
      <div>
        <p class="eyebrow">Reports Center</p>
        <h1>Inventory Reports</h1>
      </div>
      <div class="header-meta">
        <a class="btn btn-secondary" href="/dashboard">Back to Dashboard</a>
      </div>
    </header>

    <section class="grid grid--cards">
      <a class="card card-link" href="ExpiredServlet">
        <h2>Expired Items</h2>
        <p>Review all inventory records that are past their expiry date.</p>
      </a>
      <a class="card card-link" href="LowStockServlet">
        <h2>Low Stock Alerts</h2>
        <p>See products that need restocking soon.</p>
      </a>
    </section>
  </div>
</body>
</html>