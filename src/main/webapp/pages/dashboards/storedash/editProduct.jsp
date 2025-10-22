<%@ page import="com.dailyfixer.dao.ProductDAO" %>
<%@ page import="com.dailyfixer.model.Product" %>
<%
  int id = Integer.parseInt(request.getParameter("productId"));
  Product product = new ProductDAO().getProductById(id);
%>
<html>
<head>
  <title>Edit Product - DailyFixer</title>
  <style>
    /* ==== DASHBOARD THEME CSS ==== */
    body {
      background: linear-gradient(to bottom, #ffffff, #c8d9ff);
      color: #333;
      line-height: 1.6;
      font-family: Arial, sans-serif;
      margin: 0;
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

<main>
  <div class="form-card">
    <h2>Edit Product</h2>

    <form action="${pageContext.request.contextPath}/EditProductServlet" method="post" enctype="multipart/form-data">
      <input type="hidden" name="productId" value="<%=product.getProductId()%>">

      <label>Product Name</label>
      <input type="text" name="name" value="<%=product.getName()%>" placeholder="Product Name" required>

      <label>Category</label>
      <select name="type" required>
        <option value="Cutting Tools" <%=product.getType().equals("Cutting Tools")?"selected":""%>>Cutting Tools</option>
        <option value="Painting Tools" <%=product.getType().equals("Painting Tools")?"selected":""%>>Painting Tools</option>
        <option value="Tool Storage & Safety Gear" <%=product.getType().equals("Tool Storage & Safety Gear")?"selected":""%>>Tool Storage & Safety Gear</option>
        <option value="Electrical Tools & Accessories" <%=product.getType().equals("Electrical Tools & Accessories")?"selected":""%>>Electrical Tools & Accessories</option>
        <option value="Power Tools" <%=product.getType().equals("Power Tools")?"selected":""%>>Power Tools</option>
        <option value="Cleaning & Maintenance" <%=product.getType().equals("Cleaning & Maintenance")?"selected":""%>>Cleaning & Maintenance</option>
        <option value="Vehicle Parts & Accessories" <%=product.getType().equals("Vehicle Parts & Accessories")?"selected":""%>>Vehicle Parts & Accessories</option>
        <option value="Measuring & Marking Tools" <%=product.getType().equals("Measuring & Marking Tools")?"selected":""%>>Measuring & Marking Tools</option>
        <option value="Tapes" <%=product.getType().equals("Tapes")?"selected":""%>>Tapes</option>
        <option value="Fasteners & Fittings" <%=product.getType().equals("Fasteners & Fittings")?"selected":""%>>Fasteners & Fittings</option>
        <option value="Plumbing Tools & Supplies" <%=product.getType().equals("Plumbing Tools & Supplies")?"selected":""%>>Plumbing Tools & Supplies</option>
        <option value="Adhesives & Sealants" <%=product.getType().equals("Adhesives & Sealants")?"selected":""%>>Adhesives & Sealants</option>
      </select>

      <label>Quantity</label>
      <input type="number" step="0.01" name="quantity" value="<%=product.getQuantity()%>" placeholder="Quantity" required>

      <label>Quantity Unit</label>
      <select name="quantityUnit" required>
        <option value="No of items" <%=product.getQuantityUnit().equals("No of items")?"selected":""%>>No of items</option>
        <option value="Litres" <%=product.getQuantityUnit().equals("Litres")?"selected":""%>>Litres</option>
        <option value="Kg" <%=product.getQuantityUnit().equals("Kg")?"selected":""%>>Kg</option>
        <option value="Metres" <%=product.getQuantityUnit().equals("Metres")?"selected":""%>>Metres</option>
      </select>

      <label>Price</label>
      <input type="number" step="0.01" name="price" value="<%=product.getPrice()%>" placeholder="Price" required>

      <label>Product Image</label>
      <input type="file" name="image" accept="image/*">

      <button type="submit">Update Product</button>
    </form>

    <a href="${pageContext.request.contextPath}/ListProductsServlet" class="back-btn">Back to Products</a>
  </div>
</main>

</body>
</html>
