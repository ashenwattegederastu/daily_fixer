<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,com.dailyfixer.dao.GuideDAO,com.dailyfixer.model.Guide" %>
<%@ page import="com.dailyfixer.model.User" %>

<%
  User currentUser = (User) session.getAttribute("currentUser");
  if (currentUser == null || !"volunteer".equalsIgnoreCase(currentUser.getRole())) {
    response.sendRedirect(request.getContextPath() + "/pages/shared/login.jsp");
    return;
  }

  int userId = currentUser.getUserId();
  GuideDAO dao = new GuideDAO();
  List<Guide> myGuides = dao.getGuidesByCreator(userId);
  
  String success = request.getParameter("success");
  String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>My Guides | Daily Fixer</title>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/framework.css">
<style>
.container {
    flex:1;
    margin-left:240px;
    margin-top:83px;
    padding:30px;
}
.container h2 {
    font-size:1.6em;
    margin-bottom:20px;
    color: var(--foreground);
}
.guide-container {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    gap: 20px;
    margin-top: 20px;
}
.guide-card {
    background: var(--card);
    border-radius: var(--radius-lg);
    padding: 20px;
    box-shadow: var(--shadow-sm);
    border: 1px solid var(--border);
    text-align: center;
    transition: transform 0.2s ease;
}
.guide-card:hover {
    transform: translateY(-5px);
    box-shadow: var(--shadow-md);
}
.guide-card img {
    width: 100%;
    height: 150px;
    object-fit: cover;
    border-radius: var(--radius-md);
    margin-bottom: 15px;
}
.guide-card .title-link {
    display: block;
    font-weight: 600;
    color: var(--foreground);
    text-decoration: none;
    font-size: 1.1em;
    margin-bottom: 10px;
}
.guide-card .title-link:hover {
    color: var(--primary);
}
.guide-meta {
    display: flex;
    gap: 0.5rem;
    justify-content: center;
    flex-wrap: wrap;
    margin-bottom: 10px;
}
.category-tag {
    font-size: 0.7rem;
    padding: 0.2rem 0.5rem;
    background: var(--accent);
    color: var(--accent-foreground);
    border-radius: var(--radius-sm);
}
.btn-group {
    display: flex;
    justify-content: center;
    gap: 10px;
    margin-top: 15px;
}
.guide-btn {
    padding: 8px 16px;
    border-radius: var(--radius-md);
    color: white;
    font-weight: 500;
    text-decoration: none;
    transition: all 0.2s;
    font-size: 0.9em;
}
.guide-btn.edit { 
    background: var(--primary);
}
.guide-btn.edit:hover { 
    opacity: 0.9;
    transform: translateY(-1px);
}
.guide-btn.delete { 
    background: var(--destructive);
}
.guide-btn.delete:hover { 
    opacity: 0.9;
    transform: translateY(-1px);
}
.add-guide-btn {
    display: inline-block;
    margin-bottom: 20px;
    padding: 12px 24px;
    background: var(--primary);
    color: var(--primary-foreground);
    font-weight: 600;
    border-radius: var(--radius-md);
    text-decoration: none;
    transition: all 0.2s;
    box-shadow: var(--shadow-sm);
}
.add-guide-btn:hover {
    opacity: 0.9;
    transform: translateY(-2px);
    box-shadow: var(--shadow-md);
}
.empty-state {
    text-align: center;
    padding: 40px;
    color: var(--muted-foreground);
    font-size: 1.1em;
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
    <div class="panel-name">Volunteer Panel</div>
    <div style="display: flex; align-items: center; gap: 10px;">
        <button id="theme-toggle-btn" class="theme-toggle" onclick="toggleTheme()" aria-label="Toggle dark mode">🌙 Dark</button>
        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Log Out</a>
    </div>
</header>

<aside class="sidebar">
    <h3>Navigation</h3>
    <ul>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/volunteerdash/volunteerdashmain.jsp">Dashboard</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/volunteerdash/myguides.jsp" class="active">My Guides</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/volunteerdash/guideComments.jsp">Guide Comments</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/volunteerdash/notifications.jsp">Notifications</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/volunteerdash/addGuide.jsp">Add Guide</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/volunteerdash/myProfile.jsp">My Profile</a></li>
    </ul>
</aside>

<main class="container">
    <h2>My Guides</h2>
    
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
    
    <a href="${pageContext.request.contextPath}/pages/dashboards/volunteerdash/addGuide.jsp" class="add-guide-btn">+ Add New Guide</a>

    <% if (myGuides != null && !myGuides.isEmpty()) { %>
    <div class="guide-container">
      <% for (Guide g : myGuides) { %>
      <div class="guide-card">
        <img src="${pageContext.request.contextPath}/ImageServlet?id=<%= g.getGuideId() %>" alt="Guide Image"
             onerror="this.src='${pageContext.request.contextPath}/assets/images/placeholder.jpg'">
        <a href="${pageContext.request.contextPath}/ViewGuideServlet?id=<%= g.getGuideId() %>" class="title-link"><%= g.getTitle() %></a>
        <div class="guide-meta">
            <span class="category-tag"><%= g.getMainCategory() %></span>
            <span class="category-tag"><%= g.getSubCategory() %></span>
        </div>
        <div class="btn-group">
          <a href="${pageContext.request.contextPath}/EditGuideServlet?id=<%= g.getGuideId() %>" class="guide-btn edit">Edit</a>
          <a href="${pageContext.request.contextPath}/DeleteGuideServlet?id=<%= g.getGuideId() %>" class="guide-btn delete" onclick="return confirm('Are you sure you want to delete this guide?');">Delete</a>
        </div>
      </div>
      <% } %>
    </div>
    <% } else { %>
    <div class="empty-state">
        <p>You haven't added any guides yet.</p>
        <p>Click "Add New Guide" to get started!</p>
    </div>
    <% } %>
</main>

<script src="${pageContext.request.contextPath}/assets/js/dark-mode.js"></script>
</body>
</html>
