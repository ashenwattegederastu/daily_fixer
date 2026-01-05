<%--
  Created by IntelliJ IDEA.
  User: pooja
  Date: 12/23/2025
  Time: 4:24 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="java.util.List" %>
<%@ page import="com.dailyfixer.model.Product" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daily Fixer - <%= request.getAttribute("category") %></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/cutting_tool.css">
    <jsp:include page="fragment_cart.jsp"/>
</head>
<body>
<!-- Navigation -->
<nav id="navbar">
    <div class="nav-container">
        <div class="logo">Daily Fixer</div>
        <ul class="nav-links">
            <li><a href="${pageContext.request.contextPath}/diagnostic.jsp">Diagnostic Tool</a></li>
            <li><a href="${pageContext.request.contextPath}/listguides.jsp">View Repair Guides</a></li>
            <li><a href="${pageContext.request.contextPath}/findtech.jsp">Book a Technician</a></li>
            <li><a href="${pageContext.request.contextPath}/store_main.jsp">Store</a></li>
        </ul>
        <div class="nav-buttons">
            <button class="btn-login">Login</button>
            <button class="btn-signup">Sign Up</button>
        </div>
    </div>
</nav>

<!-- Search & Filter Section -->
<section class="search-section">
    <h3 class="search-title">Find <%= request.getAttribute("category") %></h3>
    <div class="search-box">
        <input type="text" placeholder="Search for a tool...">
        <button><img src="${pageContext.request.contextPath}/assets/images/search.png" alt="Search"></button>
    </div>
</section>

<div class="cutting-tools-container">
    <!-- Left Filter Card -->
    <div class="filter-card">
        <h3>Set Your Location</h3>
        <input type="text" placeholder="Enter your city or area">
        <button class="btn-set-location">Set Location</button>

        <h3>Sort Products</h3>
        <select>
            <option>Default</option>
            <option>Price: Low to High</option>
            <option>Price: High to Low</option>
            <option>Newest</option>
        </select>
    </div>

    <!-- Right Product List -->
    <div class="product-list-card">
        <h3>Available <%= request.getAttribute("category") %></h3>
        <div class="product-grid">
            <%
                List<Product> products = (List<Product>) request.getAttribute("products");
                if (products != null && !products.isEmpty()) {
                    for (Product p : products) {
            %>
            <div class="product-card">
                <img src="data:image/jpeg;base64,<%=p.getImageBase64()%>" alt="<%=p.getName()%>">
                <h4><%=p.getName()%></h4>
                <p class="desc"><%=p.getDescription()%></p>
                <p class="price">Rs. <%=p.getPrice()%></p>
                <button class="btn-buy" onclick="window.location.href='product_details.jsp?productId=<%=p.getProductId()%>'">
                    View Details
                </button>

            </div>
            <%
                }
            } else {
            %>
            <p>No products available in this category.</p>
            <% } %>
        </div>
    </div>
</div>

</body>
</html>
