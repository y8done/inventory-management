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
        <h1>System Reports</h1>
      </div>
      <div class="header-meta">
        <a class="btn btn-secondary" href="/dashboard">Back to Dashboard</a>
      </div>
    </header>

    <section class="grid grid--cards">
      <div class="card">
        <h2>Inventory Health</h2>
        <p>Monitor expired items, low stock issues, and stock availability trends.</p>
      </div>
      <div class="card">
        <h2>Manager Activity</h2>
        <p>Review manager account access and recent actions across the system.</p>
      </div>
      <a class="card card-link" href="/alerts">
        <h2>Alert Overview</h2>
        <p>Inspect current expired item and low stock alerts in one place.</p>
      </a>
      <div class="card">
        <h2>Compliance Summary</h2>
        <p>Track system stability and compliance-related inventory findings.</p>
      </div>
    </section>

    <section class="card table-card">
      <div class="table-header">
        <h2>Quick Metrics</h2>
        <p>Current system report highlights.</p>
      </div>
      <table class="table-data">
        <tbody>
          <tr>
            <th>Total managers</th>
            <td><%= request.getAttribute("managerCount") != null ? request.getAttribute("managerCount") : "—" %></td>
          </tr>
          <tr>
            <th>Expired items</th>
            <td><%= request.getAttribute("expiredCount") != null ? request.getAttribute("expiredCount") : "—" %></td>
          </tr>
          <tr>
            <th>Low stock items</th>
            <td><%= request.getAttribute("lowStockCount") != null ? request.getAttribute("lowStockCount") : "—" %></td>
          </tr>
          <tr>
            <th>Open alerts</th>
            <td><%= request.getAttribute("alertCount") != null ? request.getAttribute("alertCount") : "—" %></td>
          </tr>
        </tbody>
      </table>
    </section>
  </div>
</body>
</html>