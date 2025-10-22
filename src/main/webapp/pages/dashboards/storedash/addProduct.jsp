<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,com.dailyfixer.model.Product" %>
<%@ page import="com.dailyfixer.model.User" %>
<%
  User user = (User) session.getAttribute("currentUser");
  if (user == null || !"store".equals(user.getRole())) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
  }

//  List<Product> products = (List<Product>) request.getAttribute("products");
%>
<html>
<head>
  <title>Add Product - DailyFixer</title>
  <style>
    /* ==== DASHBOARD THEME CSS ==== */
    body {
      background: linear-gradient(to bottom, #ffffff, #c8d9ff);
      color: #333;
      line-height: 1.6;
      font-family: Arial, sans-serif;
    }

    header {
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      z-index: 1000;
    }

    .navbar {
      display: flex;
      justify-content: space-between;
      align-items: center;
      background-color: #7c8cff;
      padding: 10px 30px;
      border-top-left-radius: 10px;
      border-top-right-radius: 10px;
    }

    .logo {
      font-size: 22px;
      font-weight: bold;
      color: white;
    }

    .nav-links {
      list-style: none;
      display: flex;
      gap: 30px;
      margin: 0;
      padding: 0;
    }

    .nav-links li a {
      text-decoration: none;
      color: white;
      font-weight: bold;
    }

    .subnav {
      background-color: #cfe0ff;
      display: flex;
      justify-content: center;
      gap: 50px;
      padding: 12px 20px;
      border-radius: 50px;
      margin-top: 5px;
      border: 1px solid #a6c0ff;
    }

    .subnav .store-name {
      font-weight: bold;
      margin-right: 45rem;
      font-family: 'Arial', sans-serif;
      font-size: 20px;
    }

    .subnav ul {
      list-style: none;
      display: flex;
      gap: 2rem;
      padding: 0;
      margin: 0;
    }

    .subnav a {
      text-decoration: none;
      color: #333;
      font-weight: 500;
    }

    .subnav a:hover {
      color: #7c8cff;
    }

    .container {
      max-width: 1200px;
      margin: 0 auto;
      padding: 0 1.5rem;
    }

    main {
      padding: 2rem;
      margin-top: 160px;
      display: flex;
      justify-content: center;
      align-items: flex-start;
    }

    .form-card {
      background: white;
      border-radius: 10px;
      padding: 2rem;
      max-width: 600px;
      width: 100%;
      box-shadow: 0 4px 10px rgba(0,0,0,0.1);
    }

    .form-card h2 {
      color: #0059b3;
      text-align: center;
      margin-bottom: 1.5rem;
    }

    .form-card label {
      display: block;
      font-weight: bold;
      color: #6b77cf;
      margin-top: 1rem;
    }

    .form-card input,
    .form-card select {
      width: 100%;
      padding: 10px;
      border: none;
      border-radius: 8px;
      background: #ecf1fe;
      margin-top: 0.3rem;
    }

    .form-card button {
      background: #7c8cff;
      color: white;
      width: 100%;
      padding: 10px;
      border: none;
      border-radius: 8px;
      cursor: pointer;
      margin-top: 1.5rem;
      font-weight: bold;
    }

    .form-card button:hover {
      background: #6b7aff;
    }

    .back-btn {
      background: #1b2647;
      color: white;
      padding: 0.6rem 1.2rem;
      border: none;
      border-radius: 6px;
      cursor: pointer;
      text-decoration: none;
      display: inline-block;
      margin-top: 1rem;
      text-align: center;
    }

    .back-btn:hover {
      background: #111a33;
    }
  </style>
</head>
<body>

<header>
  <div class="navbar">
    <div class="logo">DailyFixer</div>
    <ul class="nav-links">
      <li><a href="#">Home</a></li>
      <li><a href="#">Orders</a></li>
      <li><a href="#">Profile</a></li>
    </ul>
  </div>

  <div class="subnav">
    <div class="store-name">Store Dashboard</div>
    <ul>
      <li><a href="#">Dashboard</a></li>
      <li><a href="#">Products</a></li>
      <li><a href="#" class="active">Add Product</a></li>
    </ul>
  </div>
</header>

<main>
  <div class="form-card">
    <h2>Add Product</h2>

    <form action="${pageContext.request.contextPath}/AddProductServlet" method="post" enctype="multipart/form-data">

      <label for="name">Product Name</label>
      <input type="text" name="name" placeholder="Product Name" required>

      <label for="type">Category</label>
      <select name="type" required>
        <option value="">-- Select Category --</option>
        <option value="Cutting Tools">Cutting Tools</option>
        <option value="Painting Tools">Painting Tools</option>
        <option value="Tool Storage & Safety Gear">Tool Storage & Safety Gear</option>
        <option value="Electrical Tools & Accessories">Electrical Tools & Accessories</option>
        <option value="Power Tools">Power Tools</option>
        <option value="Cleaning & Maintenance">Cleaning & Maintenance</option>
        <option value="Vehicle Parts & Accessories">Vehicle Parts & Accessories</option>
        <option value="Measuring & Marking Tools">Measuring & Marking Tools</option>
        <option value="Tapes">Tapes</option>
        <option value="Fasteners & Fittings">Fasteners & Fittings</option>
        <option value="Plumbing Tools & Supplies">Plumbing Tools & Supplies</option>
        <option value="Adhesives & Sealants">Adhesives & Sealants</option>
      </select>

      <label for="quantity">Quantity</label>
      <input type="number" step="0.01" name="quantity" placeholder="Quantity" required>

      <label for="quantityUnit">Unit</label>
      <select name="quantityUnit" required>
        <option value="No of items">No of items</option>
        <option value="Litres">Litres</option>
        <option value="Kg">Kg</option>
        <option value="Metres">Metres</option>
      </select>

      <label for="price">Price</label>
      <input type="number" step="0.01" name="price" placeholder="Price" required>

      <label for="image">Product Image</label>
      <input type="file" name="image" accept="image/*" required>

      <button type="submit">Add Product</button>
    </form>

    <a href="${pageContext.request.contextPath}/ListProductsServlet" class="back-btn">Back to Products</a>
  </div>
</main>

</body>
</html>
