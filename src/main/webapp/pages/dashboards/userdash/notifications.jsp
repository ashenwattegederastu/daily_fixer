<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page import="com.dailyfixer.model.User" %>
<%@ page import="com.dailyfixer.model.UserNotification" %>
<%@ page import="com.dailyfixer.dao.UserNotificationDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.Comparator" %>

<%
    User user = (User) session.getAttribute("currentUser");
    if (user == null || user.getRole() == null ||
            !"user".equalsIgnoreCase(user.getRole().trim())) {
        response.sendRedirect(request.getContextPath() + "/pages/shared/login.jsp");
        return;
    }
    UserNotificationDAO notifDAO = new UserNotificationDAO();
    List<UserNotification> notifications = notifDAO.findByUserId(user.getUserId());
    String sortParam = request.getParameter("sort");
    if (notifications != null && "date_asc".equals(sortParam)) {
        Collections.sort(notifications, new Comparator<UserNotification>() {
            public int compare(UserNotification a, UserNotification b) {
                if (a.getCreatedAt() == null && b.getCreatedAt() == null) return 0;
                if (a.getCreatedAt() == null) return 1;
                if (b.getCreatedAt() == null) return -1;
                return a.getCreatedAt().compareTo(b.getCreatedAt());
            }
        });
    }
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM d, yyyy 'at' HH:mm");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Notifications | Daily Fixer</title>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&family=Inter:wght@400;500;600;700&family=Lora:wght@400;500;600;700&family=IBM+Plex+Mono:wght@400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/framework.css">
<style>
.topbar-actions { display: flex; gap: 15px; align-items: center; }
.topbar .home-btn {
    padding: 0.6rem 1.2rem;
    background: var(--chart-1);
    border: none;
    color: white;
    border-radius: var(--radius-md);
    cursor: pointer;
    font-weight: 600;
    font-size: 0.9rem;
    text-decoration: none;
    display: inline-block;
    transition: all 0.3s ease;
}
.topbar .home-btn:hover { transform: translateY(-2px); box-shadow: var(--shadow-md); opacity: 0.9; }

.container h2 { font-size: 1.6em; margin-bottom: 24px; color: var(--foreground); }

/* Notification cards – match dashboard card style */
.notification-card {
    background: var(--card);
    padding: 24px;
    border-radius: var(--radius-lg);
    box-shadow: var(--shadow-lg);
    border: 1px solid var(--border);
    margin-bottom: 20px;
    display: flex;
    align-items: flex-start;
    gap: 20px;
    transition: all 0.25s ease;
    color: var(--foreground);
}
.notification-card:hover {
    box-shadow: var(--shadow-xl);
    transform: translateY(-2px);
    border-color: var(--primary);
}

.notification-icon {
    width: 48px;
    height: 48px;
    min-width: 48px;
    border-radius: var(--radius-md);
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: bold;
    color: white;
    font-size: 1.3em;
}
.notification-icon.accepted { background: var(--chart-1); }
.notification-icon.denied { background: var(--destructive); }
.notification-icon.delivery { background: var(--chart-2); }
.notification-icon.pending { background: var(--chart-3); }

.notification-body { flex: 1; min-width: 0; }
.notification-body h4 {
    margin: 0 0 8px 0;
    color: var(--foreground);
    font-size: 1.15em;
    font-weight: 600;
}
.notification-body .notification-desc {
    margin: 0 0 12px 0;
    color: var(--muted-foreground);
    font-size: 0.95em;
    line-height: 1.45;
}
.notification-details-box {
    background: var(--muted);
    border-left: 4px solid var(--primary);
    padding: 12px 14px;
    border-radius: var(--radius-md);
    margin: 12px 0 16px 0;
    font-size: 0.9em;
    color: var(--foreground);
    white-space: pre-line;
    line-height: 1.5;
}
.notification-actions-row {
    display: flex;
    gap: 12px;
    flex-wrap: wrap;
    margin-top: 16px;
}
.btn-view-details {
    padding: 10px 20px;
    background: var(--primary);
    color: var(--primary-foreground);
    border: none;
    border-radius: var(--radius-md);
    font-weight: 600;
    font-size: 0.9rem;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    gap: 8px;
    transition: all 0.2s;
    cursor: pointer;
    box-shadow: var(--shadow-sm);
}
.btn-view-details:hover {
    transform: translateY(-1px);
    box-shadow: var(--shadow-md);
    opacity: 0.95;
}
.btn-download-receipt {
    padding: 10px 20px;
    background: var(--chart-1);
    color: white;
    border: none;
    border-radius: var(--radius-md);
    font-weight: 600;
    font-size: 0.9rem;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    gap: 8px;
    transition: all 0.2s;
    cursor: pointer;
    box-shadow: var(--shadow-sm);
}
.btn-download-receipt:hover {
    transform: translateY(-1px);
    box-shadow: var(--shadow-md);
    opacity: 0.95;
}

.notification-meta {
    display: flex;
    flex-direction: column;
    align-items: flex-end;
    gap: 10px;
    flex-shrink: 0;
}
.notification-time {
    color: var(--muted-foreground);
    font-size: 0.85em;
    font-weight: 500;
}
.notification-status {
    padding: 6px 14px;
    border-radius: 999px;
    font-size: 0.8em;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.02em;
}
.status-accepted { background: oklch(0.9 0.08 156); color: oklch(0.3 0.12 156); }
.status-denied { background: oklch(0.95 0.06 25); color: oklch(0.45 0.15 25); }
.status-delivery { background: oklch(0.92 0.06 250); color: oklch(0.4 0.15 250); }
.status-pending { background: oklch(0.95 0.08 85); color: oklch(0.45 0.12 85); }

.section-header {
    font-size: 1.15em;
    font-weight: 600;
    color: var(--foreground);
    margin: 28px 0 16px 0;
    padding-bottom: 10px;
    border-bottom: 2px solid var(--border);
}
.sort-bar {
    display: flex;
    align-items: center;
    gap: 12px;
    margin-bottom: 20px;
    flex-wrap: wrap;
}
.sort-bar span {
    font-size: 0.95em;
    color: var(--muted-foreground);
    font-weight: 500;
}
.sort-bar a {
    padding: 8px 16px;
    border-radius: var(--radius-md);
    font-size: 0.9em;
    font-weight: 600;
    text-decoration: none;
    background: var(--secondary);
    color: var(--secondary-foreground);
    border: 1px solid var(--border);
    transition: all 0.2s;
}
.sort-bar a:hover {
    background: var(--accent);
    color: var(--accent-foreground);
}
.sort-bar a.sort-active {
    background: var(--primary);
    color: var(--primary-foreground);
    border-color: var(--primary);
}
.empty-state {
    text-align: center;
    padding: 60px 24px;
    background: var(--card);
    border-radius: var(--radius-lg);
    border: 1px solid var(--border);
    color: var(--muted-foreground);
}
.empty-state h3 { margin-bottom: 12px; color: var(--foreground); font-size: 1.25em; }
.empty-state p { font-size: 0.95em; line-height: 1.5; }
</style>
</head>
<body>

<header class="topbar">
    <div class="logo">Daily Fixer</div>
    <div class="panel-name">User Panel</div>
    <div class="topbar-actions">
        <button id="theme-toggle-btn" class="theme-toggle" onclick="toggleTheme()" aria-label="Toggle dark mode">🌙 Dark</button>
        <a href="${pageContext.request.contextPath}" class="home-btn">Home</a>
        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Log Out</a>
    </div>
</header>

<aside class="sidebar">
<%--    <h3>Navigation</h3>--%>
    <ul>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/userdash/userdashmain.jsp">Dashboard</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/userdash/notifications.jsp" class="active">Notifications</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/userdash/myBookings.jsp">My Bookings</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/userdash/myPurchases.jsp">My Purchases</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/userdash/myProfile.jsp">My Profile</a></li>
    </ul>
</aside>

<main class="container">
    <h2>Notifications</h2>
    
    <% if (notifications != null && !notifications.isEmpty()) { %>
    <div class="sort-bar">
        <span>Sort:</span>
        <a href="${pageContext.request.contextPath}/pages/dashboards/userdash/notifications.jsp?sort=date_asc" class="<%= "date_asc".equals(sortParam) ? "sort-active" : "" %>">Earliest to latest</a>
        <a href="${pageContext.request.contextPath}/pages/dashboards/userdash/notifications.jsp?sort=date_desc" class="<%= "date_asc".equals(sortParam) ? "" : "sort-active" %>">Latest to earliest</a>
    </div>
    <% } %>
    
    <div class="section-header">Recent Notifications</div>
    
    <%
        if (notifications == null || notifications.isEmpty()) {
    %>
    <div class="empty-state">
        <h3>No notifications yet</h3>
        <p>When you place an order successfully, you'll see an order success notification here with order details and an option to download your receipt.</p>
    </div>
    <%
        } else {
            for (UserNotification n : notifications) {
                String bodyEscaped = (n.getBody() != null ? n.getBody().replace("<", "&lt;").replace(">", "&gt;") : "");
                String timeStr = (n.getCreatedAt() != null ? dateFormat.format(n.getCreatedAt()) : "");
                String orderIdEnc = (n.getOrderId() != null ? java.net.URLEncoder.encode(n.getOrderId(), "UTF-8") : "");
                boolean isOrderSuccess = "ORDER_SUCCESS".equals(n.getType());
                boolean isOrderUnsuccessful = "ORDER_UNSUCCESSFUL".equals(n.getType());
    %>
    <% if (isOrderSuccess && n.getOrderId() != null && !n.getOrderId().isEmpty()) { %>
    <div class="notification-card">
        <div class="notification-icon accepted">✓</div>
        <div class="notification-body">
            <h4><%= n.getTitle() %></h4>
            <p class="notification-desc">Your order was placed successfully. View full order and store details, or download your receipt.</p>
            <% if (n.getBody() != null && !n.getBody().isEmpty()) { %>
            <div class="notification-details-box"><%= bodyEscaped %></div>
            <% } %>
            <div class="notification-actions-row">
                <a href="${pageContext.request.contextPath}/OrderDetails.jsp?order_id=<%= orderIdEnc %>" class="btn-view-details">View details →</a>
                <a href="${pageContext.request.contextPath}/OrderDetails.jsp?order_id=<%= orderIdEnc %>" class="btn-download-receipt" target="_blank">📄 Download receipt</a>
            </div>
        </div>
        <div class="notification-meta">
            <span class="notification-time"><%= timeStr %></span>
            <span class="notification-status status-accepted">Order placed</span>
        </div>
    </div>
    <% } else if (isOrderSuccess) { %>
    <div class="notification-card">
        <div class="notification-icon accepted">✓</div>
        <div class="notification-body">
            <h4><%= n.getTitle() %></h4>
            <p class="notification-desc">Your order is successful.</p>
            <% if (n.getBody() != null && !n.getBody().isEmpty()) { %><div class="notification-details-box"><%= bodyEscaped %></div><% } %>
        </div>
        <div class="notification-meta">
            <span class="notification-time"><%= timeStr %></span>
            <span class="notification-status status-accepted">Order placed</span>
        </div>
    </div>
    <% } else if (isOrderUnsuccessful) { %>
    <div class="notification-card">
        <div class="notification-icon denied">✕</div>
        <div class="notification-body">
            <h4><%= n.getTitle() %></h4>
            <p class="notification-desc">Your order could not be completed. Payment was cancelled or failed.</p>
            <% if (n.getBody() != null && !n.getBody().isEmpty()) { %><div class="notification-details-box"><%= bodyEscaped %></div><% } %>
        </div>
        <div class="notification-meta">
            <span class="notification-time"><%= timeStr %></span>
            <span class="notification-status status-denied">Unsuccessful</span>
        </div>
    </div>
    <% } else { %>
    <div class="notification-card">
        <div class="notification-icon pending">📋</div>
        <div class="notification-body">
            <h4><%= n.getTitle() %></h4>
            <% if (n.getBody() != null && !n.getBody().isEmpty()) { %><p class="notification-desc"><%= bodyEscaped %></p><% } %>
        </div>
        <div class="notification-meta">
            <span class="notification-time"><%= timeStr %></span>
            <span class="notification-status status-pending">Info</span>
        </div>
    </div>
    <% } %>
    <%
            }
        }
    %>
</main>

<script src="${pageContext.request.contextPath}/assets/js/dark-mode.js"></script>
</body>
</html>
