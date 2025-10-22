<%@ page import="java.util.*,com.dailyfixer.model.Product" %>
<%@ page import="com.dailyfixer.model.User" %>
<%
  User user = (User) session.getAttribute("currentUser");
  if (user == null || !"store".equals(user.getRole())) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
  }

  List<Product> products = (List<Product>) request.getAttribute("products");
%>
<html>
<head>
  <title>Products - DailyFixer</title>
  <style>
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
    .logo { font-size: 22px; font-weight: bold; color: white; }
    .nav-links { list-style: none; display: flex; gap: 30px; margin: 0; padding: 0; }
    .nav-links li a { text-decoration: none; color: white; font-weight: bold; }
    .subnav {
      background-color: #cfe0ff;
      display: flex;
      flex-wrap: wrap;
      align-items: center;
      justify-content: space-between;
      padding: 12px 20px;
      border-radius: 50px;
      margin-top: 5px;
      border: 1px solid #a6c0ff;
      gap: 10px;
    }
    .subnav .store-name { font-weight: bold; font-size: 20px; }
    .subnav ul { list-style: none; display: flex; gap: 2rem; padding: 0; margin: 0; }
    .subnav a { text-decoration: none; color: #333; font-weight: 500; padding: 6px 12px; border-radius: 4px; }
    .subnav a.active, .subnav a:hover { color: #7c8cff; }
    .container { max-width: 1200px; margin: 0 auto; padding: 140px 1.5rem 2rem; }

    /* Top Bar */
    .top-bar {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 20px;
    }
    .top-bar h2 { color: #0059b3; }
    .btn-add { background: #7c8cff; color: white; padding: 8px 14px; border-radius: 6px; text-decoration: none; font-weight: bold; }
    .btn-add:hover { background: #6b7aff; }

    /* Updated Table Styling */
    table {
      width: 100%;
      border-collapse: collapse;
      background: white;
      box-shadow: 0 3px 8px rgba(0,0,0,0.1);
      border-radius: 12px;
      overflow: hidden;
    }
    th, td {
      padding: 12px 14px;
      text-align: left;
      border-bottom: 1px solid #eee;
    }
    th {
      background: #7c8cff;
      color: white;
      font-weight: bold;
    }
    tr:hover {
      background-color: #f7faff;
    }
    img.service-thumb {
      width: 100px;
      height: 80px;
      border-radius: 8px;
      object-fit: cover;
    }
    .actions a {
      color: #7c8cff;
      text-decoration: none;
      font-weight: 500;
      margin-right: 10px;
    }
    .actions a:hover {
      text-decoration: underline;
    }
  </style>
</head>
<body>

<!-- Main Navbar -->
<header>
  <nav class="navbar">
    <div class="logo">Daily Fixer</div>
    <ul class="nav-links">
      <li><a href="${pageContext.request.contextPath}">Home</a></li>
      <li><a href="${pageContext.request.contextPath}/logout">Log Out</a></li>
    </ul>
  </nav>

  <!-- Subnav -->
  <nav class="subnav">
    <div class="store-name">Store Dashboard</div>
    <ul>
      <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/storedashmain.jsp">Dashboard</a></li>
      <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/orders.jsp">Orders</a></li>
      <li><a href="${pageContext.request.contextPath}/ListProductsServlet" class="active">Catalogue</a></li>
      <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/myProfile.jsp">Profile</a></li>
    </ul>
  </nav>
</header>

<div class="container">
  <!-- Top Bar -->
  <div class="top-bar">
    <h2>My Product Catalogue</h2>
    <a class="btn-add" href="${pageContext.request.contextPath}/pages/dashboards/storedash/addProduct.jsp">+ Add Product</a>
  </div>

  <!-- Products Table -->
  <table>
    <tr>
<%--      <th>ID</th>--%>
      <th>Image</th>
      <th>Name</th>
      <th>Type</th>
      <th>Quantity</th>
      <th>Price</th>
      <th>Actions</th>
    </tr>
    <% if(products != null && !products.isEmpty()){
      for(Product p : products){ %>
    <tr>
<%--      <td><%=p.getProductId()%></td>--%>
      <td>
        <% if(p.getImage() != null){ %>
        <img class="service-thumb" src="data:image/jpeg;base64,<%=java.util.Base64.getEncoder().encodeToString(p.getImage())%>">
        <% } %>
      </td>
      <td><%=p.getName()%></td>
      <td><%=p.getType()%></td>
      <td><%=p.getQuantity()%> <%=p.getQuantityUnit()%></td>
      <td>Rs. <%=p.getPrice()%></td>
      <td class="actions">
        <a href="${pageContext.request.contextPath}/pages/dashboards/storedash/editProduct.jsp?productId=<%=p.getProductId()%>">Edit</a>
        <a href="${pageContext.request.contextPath}/DeleteProductServlet?productId=<%=p.getProductId()%>">Delete</a>
      </td>
    </tr>
    <% }} else { %>
    <tr><td colspan="7" style="text-align:center; color:#777;">No products found.</td></tr>
    <% } %>
  </table>
</div>

</body>
</html>
