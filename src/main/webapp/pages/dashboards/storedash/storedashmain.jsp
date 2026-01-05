<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page import="com.dailyfixer.model.User" %>

<%
    // Get the current user from session
    User user = (User) session.getAttribute("currentUser");

    // If user is not logged in, redirect to login
    if (user == null || user.getRole() == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Check if role is admin or store; otherwise redirect
    String role = user.getRole().trim().toLowerCase();
    if (!("admin".equals(role) || "store".equals(role))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>


<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Store Dashboard | Daily Fixer</title>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&family=Inter:wght@400;500;600;700&family=Lora:wght@400;500;600;700&family=IBM+Plex+Mono:wght@400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/framework.css">
<style>
.container {
    flex:1;
    margin-left:240px;
    margin-top:83px;
    padding:30px;
    background-color: var(--background);
}

.container h2 {
    font-size:1.6em;
    margin-bottom:20px;
    color: var(--foreground);
}

/* Cards */
.cards-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 20px;
    margin-bottom: 30px;
}

.card {
    background: var(--card);
    border-radius: var(--radius-lg);
    padding: 20px;
    box-shadow: var(--shadow-lg);
    border: 1px solid var(--border);
}

.card h3 {
    color: var(--primary);
    margin-bottom: 15px;
    font-size: 1.1em;
}

.card .number {
    font-size: 2em;
    font-weight: 700;
    color: var(--foreground);
    margin-bottom: 5px;
}

.card .label {
    color: var(--muted-foreground);
    font-size: 0.9em;
}

.best-item {
    display: flex;
    align-items: center;
    gap: 15px;
}

.best-item img {
    width: 60px;
    height: 60px;
    border-radius: 8px;
    object-fit: cover;
}

.best-item-info h4 {
    color: var(--text-dark);
    margin-bottom: 5px;
}

.best-item-info p {
    color: var(--muted-foreground);
    font-size: 0.9em;
}

.low-stock-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 10px 0;
    border-bottom: 1px solid var(--border);
}

.low-stock-item:last-child {
    border-bottom: none;
}

.low-stock-item .item-name {
    font-weight: 500;
    color: var(--foreground);
}

.low-stock-item .stock-count {
    color: var(--destructive);
    font-weight: 600;
}

/* Stats Grid */
.stats-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 20px;
    margin-top: 20px;
}
</style>
</head>
<body>

<header class="topbar">
    <div class="logo">Daily Fixer</div>
    <div class="panel-name">Store Panel</div>
    <div style="display: flex; align-items: center; gap: 10px;">
        <button id="theme-toggle-btn" class="theme-toggle" onclick="toggleTheme()" aria-label="Toggle dark mode">🌙 Dark</button>
        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Log Out</a>
    </div>
</header>

<aside class="sidebar">
    <h3>Navigation</h3>
    <ul>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/storedashmain.jsp" class="active">Dashboard</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/orders.jsp">Orders</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/upfordelivery.jsp">Up for Delivery</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/completedorders.jsp">Completed Orders</a></li>
        <li><a href="${pageContext.request.contextPath}/ListProductsServlet">Catalogue</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/myProfile.jsp">Profile</a></li>
    </ul>
</aside>

<main class="container">
    <h2>Store Dashboard</h2>
    
    <!-- Key Performance Cards -->
    <div class="cards-grid">
        <div class="card">
            <h3>Best Performing Item</h3>
            <div class="best-item">
                <img src="${pageContext.request.contextPath}/assets/images/power-drill.png" alt="Power Drill">
                <div class="best-item-info">
                    <h4>Power Drill</h4>
                    <p>127 units sold this month</p>
                </div>
            </div>
        </div>
        
        <div class="card">
            <h3>Low Stock Items</h3>
            <div class="low-stock-item">
                <span class="item-name">Paint Roller</span>
                <span class="stock-count">3 left</span>
            </div>
            <div class="low-stock-item">
                <span class="item-name">Wire Cutter</span>
                <span class="stock-count">5 left</span>
            </div>
            <div class="low-stock-item">
                <span class="item-name">Safety Gloves</span>
                <span class="stock-count">2 left</span>
            </div>
        </div>
        
        <div class="card">
            <h3>Sales Units (24h)</h3>
            <div class="number">23</div>
            <div class="label">Units sold in the last 24 hours</div>
        </div>
    </div>

    <!-- General Stats -->
    <div class="stats-grid">
        <div class="stat-card">
            <div class="number">156</div>
            <p>Total Orders</p>
        </div>
        <div class="stat-card">
            <div class="number">89</div>
            <p>Completed Orders</p>
        </div>
        <div class="stat-card">
            <div class="number">12</div>
            <p>Pending Orders</p>
        </div>
        <div class="stat-card">
            <div class="number">Rs. 45,230</div>
            <p>Total Revenue</p>
        </div>
    </div>
</main>

<script src="${pageContext.request.contextPath}/assets/js/dark-mode.js"></script>

</body>
</html>

