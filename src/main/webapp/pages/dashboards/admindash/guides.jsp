<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,com.dailyfixer.dao.GuideDAO,com.dailyfixer.model.Guide" %>
<%@ page import="com.dailyfixer.model.User" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
  User currentUser = (User) session.getAttribute("currentUser");
  if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
    response.sendRedirect(request.getContextPath() + "/pages/shared/login.jsp");
    return;
  }

  String filter = request.getParameter("filter");
  GuideDAO dao = new GuideDAO();
  List<Guide> guides;
  
  if ("mine".equals(filter)) {
      guides = dao.getGuidesByCreator(currentUser.getUserId());
  } else {
      guides = dao.getAllGuides();
  }
  
  String success = request.getParameter("success");
  String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Manage Guides | Admin Dashboard</title>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/framework.css">
<style>
.filter-bar {
    display: flex;
    gap: 1rem;
    margin-bottom: 1.5rem;
    flex-wrap: wrap;
    align-items: center;
}
.filter-btn {
    padding: 0.5rem 1rem;
    border: 2px solid var(--border);
    background: var(--card);
    color: var(--foreground);
    border-radius: var(--radius-md);
    text-decoration: none;
    font-weight: 500;
    transition: all 0.2s;
}
.filter-btn:hover, .filter-btn.active {
    background: var(--primary);
    color: var(--primary-foreground);
    border-color: var(--primary);
}
.guide-table {
    width: 100%;
    border-collapse: collapse;
    background: var(--card);
    border-radius: var(--radius-lg);
    overflow: hidden;
    box-shadow: var(--shadow-sm);
}
.guide-table th, .guide-table td {
    padding: 1rem;
    text-align: left;
    border-bottom: 1px solid var(--border);
}
.guide-table th {
    background: var(--muted);
    font-weight: 600;
    color: var(--foreground);
}
.guide-table tr:hover {
    background: var(--accent);
}
.guide-table img {
    width: 60px;
    height: 40px;
    object-fit: cover;
    border-radius: var(--radius-sm);
}
.action-btns {
    display: flex;
    gap: 0.5rem;
}
.action-btn {
    padding: 0.4rem 0.8rem;
    border-radius: var(--radius-sm);
    font-size: 0.85rem;
    font-weight: 500;
    text-decoration: none;
    transition: all 0.2s;
}
.action-btn.view {
    background: var(--secondary);
    color: var(--secondary-foreground);
    border: 1px solid var(--border);
}
.action-btn.edit {
    background: var(--primary);
    color: var(--primary-foreground);
}
.action-btn.delete {
    background: var(--destructive);
    color: var(--destructive-foreground);
}
.action-btn:hover {
    opacity: 0.9;
}
.add-guide-btn {
    display: inline-block;
    margin-bottom: 1.5rem;
    padding: 0.75rem 1.5rem;
    background: var(--primary);
    color: var(--primary-foreground);
    font-weight: 600;
    border-radius: var(--radius-md);
    text-decoration: none;
    transition: all 0.2s;
}
.add-guide-btn:hover {
    opacity: 0.9;
    transform: translateY(-2px);
}
.category-tag {
    font-size: 0.75rem;
    padding: 0.2rem 0.5rem;
    background: var(--accent);
    color: var(--accent-foreground);
    border-radius: var(--radius-sm);
    display: inline-block;
    margin-right: 0.25rem;
}
.alert {
    padding: 1rem;
    border-radius: var(--radius-md);
    margin-bottom: 1rem;
    font-weight: 500;
}
.alert-success {
    background-color: oklch(0.6290 0.1902 156.4499);
    color: white;
}
.alert-error {
    background-color: var(--destructive);
    color: var(--destructive-foreground);
}
</style>
</head>
<body>

<header class="topbar">
    <a href="${pageContext.request.contextPath}/index.jsp" class="logo">Daily Fixer</a>
    <div class="panel-name">Admin Panel</div>
    <div style="display: flex; align-items: center; gap: 10px;">
        <button id="theme-toggle-btn" class="theme-toggle" onclick="toggleTheme()" aria-label="Toggle dark mode">🌙 Dark</button>
        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Log Out</a>
    </div>
</header>

<aside class="sidebar">
    <h3>Navigation</h3>
    <ul>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/admindash/admindashmain.jsp">Dashboard</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/users">User Management</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/admindash/guides.jsp" class="active">View All Guides</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/admindash/flags.jsp">Flags</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/admindash/transactions.jsp">Transactions</a></li>
    </ul>
</aside>

<main class="main-content">
    <div class="dashboard-header">
        <h1>Manage Guides</h1>
        <p>View, edit and manage all repair guides</p>
    </div>
    
    <% if ("true".equals(success)) { %>
    <div class="alert alert-success">Guide created successfully!</div>
    <% } else if ("updated".equals(success)) { %>
    <div class="alert alert-success">Guide updated successfully!</div>
    <% } else if ("deleted".equals(success)) { %>
    <div class="alert alert-success">Guide deleted successfully!</div>
    <% } %>
    
    <% if ("unauthorized".equals(error)) { %>
    <div class="alert alert-error">You are not authorized to perform this action.</div>
    <% } %>

    <a href="${pageContext.request.contextPath}/pages/dashboards/admindash/addGuide.jsp" class="add-guide-btn">+ Add New Guide</a>

    <div class="filter-bar">
        <a href="${pageContext.request.contextPath}/pages/dashboards/admindash/guides.jsp" class="filter-btn <%= filter == null || filter.isEmpty() ? "active" : "" %>">All Guides</a>
        <a href="${pageContext.request.contextPath}/pages/dashboards/admindash/guides.jsp?filter=mine" class="filter-btn <%= "mine".equals(filter) ? "active" : "" %>">My Guides Only</a>
    </div>

    <% if (guides != null && !guides.isEmpty()) { %>
    <table class="guide-table">
        <thead>
            <tr>
                <th>Image</th>
                <th>Title</th>
                <th>Category</th>
                <th>Created By</th>
                <th>Role</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <% for (Guide g : guides) { %>
            <tr>
                <td>
                    <img src="${pageContext.request.contextPath}/ImageServlet?id=<%= g.getGuideId() %>" alt="Guide"
                         onerror="this.src='${pageContext.request.contextPath}/assets/images/placeholder.jpg'">
                </td>
                <td><%= g.getTitle() %></td>
                <td>
                    <span class="category-tag"><%= g.getMainCategory() %></span>
                    <span class="category-tag"><%= g.getSubCategory() %></span>
                </td>
                <td><%= g.getCreatorName() != null ? g.getCreatorName() : "Unknown" %></td>
                <td><%= g.getCreatedRole() %></td>
                <td>
                    <div class="action-btns">
                        <a href="${pageContext.request.contextPath}/ViewGuideServlet?id=<%= g.getGuideId() %>" class="action-btn view">View</a>
                        <a href="${pageContext.request.contextPath}/EditGuideServlet?id=<%= g.getGuideId() %>" class="action-btn edit">Edit</a>
                        <a href="${pageContext.request.contextPath}/DeleteGuideServlet?id=<%= g.getGuideId() %>" class="action-btn delete" onclick="return confirm('Are you sure you want to delete this guide?');">Delete</a>
                    </div>
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
    <% } else { %>
    <div class="empty-state">
        <h3>No guides found</h3>
        <p>Click "Add New Guide" to create your first guide.</p>
    </div>
    <% } %>
</main>

<script src="${pageContext.request.contextPath}/assets/js/dark-mode.js"></script>
</body>
</html>
