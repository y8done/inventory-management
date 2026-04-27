<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Inventory Dashboard</title>
  <link rel="stylesheet" href="../css/styles.css">
</head>
<body>
  <div class="page-shell">
    <header class="page-header">
      <div>
        <p class="eyebrow">Administrator Console</p>
        <h1>System Administration</h1>
      </div>
      <div class="header-meta">
        <span class="badge">Role: Admin</span>
      </div>
    </header>

    <section class="grid grid--cards">
      <a class="card card-link" href="/manageManagers">
        <h2>Manage Managers</h2>
        <p>Create, review, and manage manager accounts.</p>
      </a>
      <a class="card card-link" href="/reports">
        <h2>System Reports</h2>
        <p>View usage, inventory health, and audit summaries.</p>
      </a>
      <a class="card card-link" href="/alerts">
        <h2>Alerts Center</h2>
        <p>Review expired items and low stock warnings.</p>
      </a>
      <a class="card card-link" href="/expiredItems">
        <h2>Expired Items</h2>
        <p>See all inventory items past their expiration date.</p>
      </a>
      <a class="card card-link" href="/lowStock">
        <h2>Low Stock Alerts</h2>
        <p>Identify products that need restocking soon.</p>
      </a>
    </section>
  </div>
</body>
</html>