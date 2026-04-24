<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Add Inventory Item</title>
  <link rel="stylesheet" href="../css/styles.css">
</head>
<body>
  <div class="page-shell">
    <section class="card form-card">
      <div class="form-header">
        <h1>Add Inventory Item</h1>
        <p>Create a new product record with expiry tracking.</p>
      </div>
      <form action="AddItemServlet" method="post" class="form-grid">
        <label>
          Item Name
          <input type="text" name="name" placeholder="Product name" required>
        </label>
        <label>
          Category
          <input type="text" name="category" placeholder="Category or type">
        </label>
        <label>
          Quantity
          <input type="number" name="quantity" min="1" placeholder="Units in stock" required>
        </label>
        <label>
          Price
          <input type="number" name="price" step="0.01" placeholder="Unit price">
        </label>
        <label>
          Expiry Date
          <input type="date" name="expiry" required>
        </label>
        <label>
          Notes
          <textarea name="notes" rows="3" placeholder="Optional notes"></textarea>
        </label>
        <div class="form-actions">
          <button type="submit" class="btn btn-primary">Save Item</button>
        </div>
      </form>
    </section>
  </div>
</body>
</html>