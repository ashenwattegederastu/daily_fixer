<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page import="com.dailyfixer.model.User" %>
<%@ page import="java.sql.*, com.dailyfixer.util.DBConnection" %>

<%
  User user = (User) session.getAttribute("currentUser");
  if (user == null || user.getRole() == null) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
  }

  String role = user.getRole().trim().toLowerCase();
  if (!"admin".equals(role)) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
  }

  // Fetch total registered users
  int totalUsers = 0;
  try (Connection conn = DBConnection.getConnection();
       PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) AS count FROM users");
       ResultSet rs = ps.executeQuery()) {

    if (rs.next()) {
      totalUsers = rs.getInt("count");
    }
  } catch (Exception e) {
    e.printStackTrace();
  }
%>

<html>
<head>
  <title>Admin Dashboard</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/deliverdashmain.css">
</head>
<body>
<header>
  <!-- Main Navbar -->
  <nav class="navbar">
    <div class="logo">Daily Fixer</div>
    <ul class="nav-links">
      <li><a href="${pageContext.request.contextPath}">Home</a></li>
      <li><a href="${pageContext.request.contextPath}/LogoutServlet">Log Out</a></li>
    </ul>
  </nav>

  <!-- Subnav -->
  <nav class="subnav">
    <div class="store-name">Administrator</div>
    <ul>
      <li><a href="#" class="active">Dashboard</a></li>
      <li><a href="#">User Management</a></li>
      <li><a href="#">Reports/Flags</a></li>
      <li><a href="#">Profile</a></li>
    </ul>
  </nav>
</header>

<div class="container">
  <main class="dashboard">
    <h2>Dashboard</h2>
    <p class="subtitle">Site Performance Index</p>

    <div class="stats-container">
      <div class="stat-card">
        <p class="number">5</p>
        <p>Site Visits Today</p>
      </div>
      <div class="stat-card">
        <p class="number">3</p>
        <p>Site Visits Month</p>
      </div>
      <div class="stat-card">
        <p class="number"><%= totalUsers %></p>
        <p>Current User Count</p>
      </div>
    </div>

    <!-- Driver Stats -->
<%--    <div class="driver-stats">--%>
<%--      <h3>Driver Stats</h3>--%>
<%--      <div class="stats-grid">--%>
<%--        <div class="info-box">--%>
<%--          <p><strong>Total Deliveries:</strong> 342</p>--%>
<%--        </div>--%>
<%--        <div class="info-box">--%>
<%--          <p><strong>Driver Rating:</strong> 4.9/5</p>--%>
<%--        </div>--%>
<%--        <div class="info-box">--%>
<%--          <p><strong>This Month:</strong> 28 deliveries</p>--%>
<%--        </div>--%>
<%--      </div>--%>
<%--    </div>--%>
  </main>
</div>
</body>
</html>
