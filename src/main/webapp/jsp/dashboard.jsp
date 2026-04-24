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
        <p class="eyebrow">Welcome back</p>
        <h1>Inventory Dashboard</h1>
      </div>
      <div class="header-meta">
        <span class="badge">Role: <%= session.getAttribute("role") != null ? session.getAttribute("role") : "Guest" %></span>
      </div>
    </header>

    <section class="grid grid--cards">
      <a class="card card-link" href="/jsp/addItems.jsp">
        <h2>Add Inventory</h2>
        <p>Record new items and expiry dates.</p>
      </a>
      <a class="card card-link" href="/ViewItemsServlet">
        <h2>View Inventory</h2>
        <p>See all available stock in one place.</p>
      </a>
      <a class="card card-link" href="/AlertServlet">
        <h2>Expiry Alerts</h2>
        <p>Review expiring and expired products.</p>
      </a>
      <a class="card card-link" href="/ReportServlet">
        <h2>Reports</h2>
        <p>Open system reports for analytics.</p>
      </a>
    </section>
  </div>
</body>
</html>