<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page import="com.dailyfixer.model.User" %>

<%
    User user = (User) session.getAttribute("currentUser");
    if (user == null || user.getRole() == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String role = user.getRole().trim().toLowerCase();
    if (!("admin".equals(role) || "technician".equals(role))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<html>
<head>
    <title>Technician Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/deliverdashmain.css">
</head>
<body>
<%--<h1>Welcome, <c:out value="${user.username}"/></h1>--%>
<%--<a href="${pageContext.request.contextPath}/LogoutServlet">Logout</a>--%>
<header>
    <!-- Main Navbar -->
    <nav class="navbar">
        <div class="logo">Daily Fixer</div>
        <ul class="nav-links">
            <%--      <li><a href="../../../index.jsp">Home</a></li>--%>
            <%--      <li><a href="#">Log in</a></li>--%>
            <li><a href="${pageContext.request.contextPath}">Home</a></li>
            <li><a href="${pageContext.request.contextPath}/logout">Log Out</a></li>
        </ul>
    </nav>

    <!-- Subnav -->
    <nav class="subnav">
        <div class="store-name">Technician Dashboard</div>
        <ul>
            <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/storedashmain.jsp" class="active">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/orders.jsp">Bookings</a></li>
            <li><a href="${pageContext.request.contextPath}/pages/dashboards/techniciandash/serviceListings.jsp">Service Listing</a></li>
            <li><a href="${pageContext.request.contextPath}/ListProductsServlet">Verification</a></li>
            <%--            <li><a href="#">Orders</a></li>--%>
            <%--      <li><a href="#">Set Rates</a></li>--%>
            <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/myProfile.jsp">Profile</a></li>
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
                <p class="number">2</p>
                <p>Current User Count</p>
            </div>
        </div>

        <!-- Driver Stats -->
        <div class="driver-stats">
            <h3>Driver Stats</h3>
            <div class="stats-grid">
                <div class="info-box">
                    <p><strong>Total Deliveries:</strong> 342</p>
                </div>
                <div class="info-box">
                    <p><strong>Driver Rating:</strong> 4.9/5</p>
                </div>
                <div class="info-box">
                    <p><strong>This Month:</strong> 28 deliveries</p>
                </div>
            </div>
        </div>
    </main>
</div>
</body>
</html>

