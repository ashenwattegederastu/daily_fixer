<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page import="com.dailyfixer.model.User" %>

<%
    User user = (User) session.getAttribute("currentUser");
    if (user == null || user.getRole() == null || !"user".equalsIgnoreCase(user.getRole().trim())) {
        response.sendRedirect(request.getContextPath() + "/pages/shared/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>My Purchases | Daily Fixer</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

<style>
:root {
    --panel-color: #dcdaff;
    --accent: #8b95ff;
    --text-dark: #000000;
    --text-secondary: #333333;
    --shadow-sm: 0 4px 12px rgba(0,0,0,0.12);
    --shadow-md: 0 8px 24px rgba(0,0,0,0.18);
    --shadow-lg: 0 12px 36px rgba(0,0,0,0.22);
}

/* Reset */
* { margin:0; padding:0; box-sizing:border-box; }
body {
    font-family: 'Inter', sans-serif;
    background-color: #ffffff;
    color: var(--text-dark);
    display: flex;
    min-height: 100vh;
}

/* Top Navbar */
.topbar {
    position: fixed;
    top:0; left:0; right:0;
    height:76px;
    background-color: var(--panel-color);
    border-bottom: 1px solid rgba(0,0,0,0.1);
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0 30px;
    z-index: 200;
    box-shadow: var(--shadow-md);
}
.topbar .logo { font-size: 1.5em; font-weight: 700; color: var(--accent); }
.topbar .panel-name { font-weight: 600; flex:1; text-align:center; color: var(--text-dark); }
.topbar-actions {
    display: flex;
    gap: 15px;
    align-items: center;
}

.topbar .home-btn {
    padding: 0.6rem 1.2rem;
    background: linear-gradient(135deg, #10b981, #059669);
    border: none;
    color: #fff;
    border-radius: 8px;
    cursor: pointer;
    font-weight: 600;
    font-size: 0.9rem;
    box-shadow: var(--shadow-sm);
    text-decoration: none;
    transition: all 0.2s;
}
.topbar .home-btn:hover {
    transform: translateY(-2px);
    box-shadow: var(--shadow-md);
    opacity: 0.9;
}

.topbar .logout-btn {
    padding: 0.6rem 1.2rem;
    background: linear-gradient(135deg, var(--accent), #7ba3d4);
    border: none;
    color: #fff;
    border-radius: 8px;
    cursor: pointer;
    font-weight: 600;
    font-size: 0.9rem;
    box-shadow: var(--shadow-sm);
    text-decoration: none;
    transition: all 0.2s;
}
.topbar .logout-btn:hover {
    transform: translateY(-2px);
    box-shadow: var(--shadow-md);
    opacity: 0.9;
}

/* Sidebar */
.sidebar {
    width: 240px;
    background-color: var(--panel-color);
    height: 100vh;
    position: fixed;
    top:0;
    left:0;
    padding-top: 96px;
    box-shadow: var(--shadow-md);
    overflow-y: auto;
    z-index: 100;
}
.sidebar h3 { padding: 0 20px 12px; font-size: 0.85em; color: var(--text-dark); text-transform: uppercase; }
.sidebar ul { list-style:none; }
.sidebar a {
    display:block;
    padding:12px 20px;
    text-decoration:none;
    color: var(--text-dark);
    font-weight:500;
    border-left:3px solid transparent;
    border-radius:0 8px 8px 0;
    margin-bottom:4px;
    transition: all 0.2s;
}
.sidebar a:hover, .sidebar a.active {
    background-color: #f0f0ff;
    border-left-color: var(--accent);
}

/* Main Content */
.container {
    flex:1;
    margin-left:240px;
    margin-top:83px;
    padding:30px;
}
.container h2 {
    font-size:1.6em;
    margin-bottom:20px;
    color: #000000;
}

/* Purchase Table */
.purchase-table {
    background: #fff;
    border-radius: 12px;
    box-shadow: var(--shadow-sm);
    border: 1px solid rgba(0,0,0,0.1);
    overflow: hidden;
    margin-bottom: 30px;
}

.purchase-table table {
    width: 100%;
    border-collapse: collapse;
}

.purchase-table th {
    background: var(--panel-color);
    padding: 15px 20px;
    text-align: left;
    font-weight: 600;
    color: var(--text-dark);
    border-bottom: 2px solid var(--accent);
}

.purchase-table td {
    padding: 15px 20px;
    border-bottom: 1px solid rgba(0,0,0,0.1);
    vertical-align: middle;
}

.purchase-table tr:hover {
    background: #f8f9ff;
}

/* Product Image */
.product-image {
    width: 60px;
    height: 60px;
    border-radius: 8px;
    border: 2px solid rgba(0,0,0,0.1);
    object-fit: cover;
}

/* Status Badges */
.status-badge {
    padding: 6px 12px;
    border-radius: 20px;
    font-size: 0.8em;
    font-weight: 600;
    text-transform: uppercase;
}

.status-packing {
    background: #fef3c7;
    color: #92400e;
}

.status-shipped {
    background: #dbeafe;
    color: #1e40af;
}

.status-delivered {
    background: #d1fae5;
    color: #065f46;
}

.status-out-for-delivery {
    background: #e0e7ff;
    color: #3730a3;
}

/* Action Buttons */
.action-buttons {
    display: flex;
    gap: 8px;
    flex-wrap: wrap;
}

.btn {
    padding: 6px 12px;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    font-weight: 500;
    font-size: 0.8em;
    transition: all 0.2s;
    text-decoration: none;
    display: inline-block;
}

.btn-review {
    background: #8b5cf6;
    color: #ffffff;
}

.btn-review:hover {
    background: #7c3aed;
}

.btn-track {
    background: #3b82f6;
    color: #ffffff;
}

.btn-track:hover {
    background: #2563eb;
}

.btn-details {
    background: #10b981;
    color: #ffffff;
}

.btn-details:hover {
    background: #059669;
}

/* Section Headers */
.section-header {
    font-size: 1.2em;
    font-weight: 600;
    color: var(--text-dark);
    margin: 30px 0 15px 0;
    padding-bottom: 10px;
    border-bottom: 2px solid var(--panel-color);
}

/* Star Rating */
.star-rating {
    color: #fbbf24;
    font-size: 1.2em;
}

.star-rating .star {
    margin-right: 2px;
}
</style>
</head>
<body>

<header class="topbar">
    <div class="logo">Daily Fixer</div>
    <div class="panel-name">User Panel</div>
    <div class="topbar-actions">
        <a href="${pageContext.request.contextPath}" class="home-btn">Home</a>
        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Log Out</a>
    </div>
</header>

<aside class="sidebar">
<%--    <h3>Navigation</h3>--%>
    <ul>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/userdash/userdashmain.jsp">Dashboard</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/userdash/notifications.jsp">Notifications</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/userdash/myBookings.jsp">My Bookings</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/userdash/myPurchases.jsp" class="active">My Purchases</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/userdash/myProfile.jsp">My Profile</a></li>
    </ul>
</aside>

<main class="container">
    <h2>My Purchases</h2>
    
    <div class="section-header">Recent Orders</div>
    
    <div class="purchase-table">
        <table>
            <thead>
                <tr>
                    <th>Product</th>
                    <th>Category</th>
                    <th>Price</th>
                    <th>Order Date</th>
                    <th>Status</th>
                    <th>Rating</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>
                        <div style="display: flex; align-items: center; gap: 10px;">
                            <img src="${pageContext.request.contextPath}/assets/images/hammer.png" alt="Hammer" class="product-image">
                            <div>
                                <strong>Heavy Duty Hammer</strong><br>
                                <small>Order #12345</small>
                            </div>
                        </div>
                    </td>
                    <td>Tools</td>
                    <td>$25.00</td>
                    <td>Oct 20, 2025</td>
                    <td><span class="status-badge status-delivered">Delivered</span></td>
                    <td>
                        <div class="star-rating">
                            <span class="star">★</span>
                            <span class="star">★</span>
                            <span class="star">★</span>
                            <span class="star">★</span>
                            <span class="star">★</span>
                        </div>
                    </td>
                    <td>
                        <div class="action-buttons">
                            <a href="${pageContext.request.contextPath}/pages/dashboards/userdash/writeReview.jsp?item=hammer" class="btn btn-review">Review</a>
                            <a href="#" class="btn btn-details">Details</a>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div style="display: flex; align-items: center; gap: 10px;">
                            <img src="${pageContext.request.contextPath}/assets/images/drill.png" alt="Drill" class="product-image">
                            <div>
                                <strong>Cordless Drill Machine</strong><br>
                                <small>Order #12346</small>
                            </div>
                        </div>
                    </td>
                    <td>Tools</td>
                    <td>$85.00</td>
                    <td>Oct 22, 2025</td>
                    <td><span class="status-badge status-out-for-delivery">Out for Delivery</span></td>
                    <td>-</td>
                    <td>
                        <div class="action-buttons">
                            <a href="#" class="btn btn-track">Track</a>
                            <a href="#" class="btn btn-details">Details</a>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div style="display: flex; align-items: center; gap: 10px;">
                            <img src="${pageContext.request.contextPath}/assets/images/paintbrush.png" alt="Paint Brush" class="product-image">
                            <div>
                                <strong>Premium Paint Brush Set</strong><br>
                                <small>Order #12347</small>
                            </div>
                        </div>
                    </td>
                    <td>Painting</td>
                    <td>$40.00</td>
                    <td>Oct 15, 2025</td>
                    <td><span class="status-badge status-delivered">Delivered</span></td>
                    <td>
                        <div class="star-rating">
                            <span class="star">★</span>
                            <span class="star">★</span>
                            <span class="star">★</span>
                            <span class="star">★</span>
                            <span class="star">☆</span>
                        </div>
                    </td>
                    <td>
                        <div class="action-buttons">
                            <a href="${pageContext.request.contextPath}/pages/dashboards/userdash/writeReview.jsp?item=paintbrush" class="btn btn-review">Review</a>
                            <a href="#" class="btn btn-details">Details</a>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div style="display: flex; align-items: center; gap: 10px;">
                            <img src="${pageContext.request.contextPath}/assets/images/screwdriver.png" alt="Screwdriver" class="product-image">
                            <div>
                                <strong>Precision Screwdriver Set</strong><br>
                                <small>Order #12348</small>
                            </div>
                        </div>
                    </td>
                    <td>Tools</td>
                    <td>$18.00</td>
                    <td>Oct 24, 2025</td>
                    <td><span class="status-badge status-packing">Packing</span></td>
                    <td>-</td>
                    <td>
                        <div class="action-buttons">
                            <a href="#" class="btn btn-details">Details</a>
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>

    <div class="section-header">Order History</div>
    
    <div class="purchase-table">
        <table>
            <thead>
                <tr>
                    <th>Product</th>
                    <th>Category</th>
                    <th>Price</th>
                    <th>Order Date</th>
                    <th>Status</th>
                    <th>Rating</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>
                        <div style="display: flex; align-items: center; gap: 10px;">
                            <img src="${pageContext.request.contextPath}/assets/images/wrench.png" alt="Wrench Set" class="product-image">
                            <div>
                                <strong>Professional Wrench Set</strong><br>
                                <small>Order #12340</small>
                            </div>
                        </div>
                    </td>
                    <td>Tools</td>
                    <td>$65.00</td>
                    <td>Sep 30, 2025</td>
                    <td><span class="status-badge status-delivered">Delivered</span></td>
                    <td>
                        <div class="star-rating">
                            <span class="star">★</span>
                            <span class="star">★</span>
                            <span class="star">★</span>
                            <span class="star">★</span>
                            <span class="star">☆</span>
                        </div>
                    </td>
                    <td>
                        <div class="action-buttons">
                            <a href="${pageContext.request.contextPath}/pages/dashboards/userdash/writeReview.jsp?item=wrench" class="btn btn-review">Review</a>
                            <a href="#" class="btn btn-details">Details</a>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div style="display: flex; align-items: center; gap: 10px;">
                            <img src="${pageContext.request.contextPath}/assets/images/level.png" alt="Level" class="product-image">
                            <div>
                                <strong>Digital Level Tool</strong><br>
                                <small>Order #12339</small>
                            </div>
                        </div>
                    </td>
                    <td>Tools</td>
                    <td>$35.00</td>
                    <td>Sep 25, 2025</td>
                    <td><span class="status-badge status-delivered">Delivered</span></td>
                    <td>
                        <div class="star-rating">
                            <span class="star">★</span>
                            <span class="star">★</span>
                            <span class="star">★</span>
                            <span class="star">★</span>
                            <span class="star">★</span>
                        </div>
                    </td>
                    <td>
                        <div class="action-buttons">
                            <a href="${pageContext.request.contextPath}/pages/dashboards/userdash/writeReview.jsp?item=level" class="btn btn-review">Review</a>
                            <a href="#" class="btn btn-details">Details</a>
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</main>

</body>
</html>
