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
  List<Guide> myGuides = dao.getGuidesByVolunteer(userId);
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Guide Comments | Daily Fixer</title>
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

/* Guide Cards */
.guide-container {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    gap: 20px;
    margin-top: 20px;
}

.guide-card {
    background: #fff;
    border-radius: 12px;
    padding: 20px;
    box-shadow: var(--shadow-sm);
    border: 1px solid rgba(0,0,0,0.1);
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
    border-radius: 8px;
    margin-bottom: 15px;
}

.guide-card .title-link {
    display: block;
    font-weight: 600;
    color: var(--text-dark);
    text-decoration: none;
    font-size: 1.1em;
    margin-bottom: 15px;
}

.guide-card .title-link:hover {
    color: var(--accent);
}

.comments-info {
    background: var(--panel-color);
    padding: 10px;
    border-radius: 8px;
    margin-bottom: 15px;
    font-size: 0.9em;
    color: var(--text-secondary);
}

.btn-group {
    display: flex;
    justify-content: center;
    gap: 10px;
    margin-top: 15px;
}

.guide-btn {
    padding: 8px 16px;
    border-radius: 8px;
    color: white;
    font-weight: 500;
    text-decoration: none;
    transition: all 0.2s;
    font-size: 0.9em;
}

.guide-btn.comments { 
    background: var(--accent);
}
.guide-btn.comments:hover { 
    background: #7a85e6;
    transform: translateY(-1px);
}

.guide-btn.view { 
    background: #28a745;
}
.guide-btn.view:hover { 
    background: #218838;
    transform: translateY(-1px);
}

.empty-state {
    text-align: center;
    padding: 40px;
    color: var(--text-secondary);
    font-size: 1.1em;
}
</style>
</head>
<body>

<header class="topbar">
    <div class="logo">Daily Fixer</div>
    <div class="panel-name">Volunteer Panel</div>
    <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Log Out</a>
</header>

<aside class="sidebar">
    <h3>Navigation</h3>
    <ul>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/volunteerdash/volunteerdashmain.jsp">Dashboard</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/volunteerdash/myguides.jsp">My Guides</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/volunteerdash/guideComments.jsp" class="active">Guide Comments</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/volunteerdash/notifications.jsp">Notifications</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/volunteerdash/addGuide.jsp">Add Guide</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/volunteerdash/myProfile.jsp">My Profile</a></li>
    </ul>
</aside>

<main class="container">
    <h2>Guide Comments</h2>
    <p style="color: var(--text-secondary); margin-bottom: 20px;">View and manage comments on your guides</p>

    <% if (myGuides != null && !myGuides.isEmpty()) { %>
    <div class="guide-container">
      <% for (Guide g : myGuides) { %>
      <div class="guide-card">
        <img src="${pageContext.request.contextPath}/ImageServlet?id=<%= g.getGuideId() %>" alt="Guide Image">
        <a href="${pageContext.request.contextPath}/ViewGuideServlet?id=<%= g.getGuideId() %>" class="title-link"><%= g.getTitle() %></a>
        
        <div class="comments-info">
            <p><strong>Comments:</strong> <span id="comment-count-<%= g.getGuideId() %>">Loading...</span></p>
            <p><strong>Rating:</strong> 4.5/5 ⭐</p>
        </div>
        
        <div class="btn-group">
          <a href="${pageContext.request.contextPath}/ViewGuideCommentsServlet?guideId=<%= g.getGuideId() %>" class="guide-btn comments">View Comments</a>
          <a href="${pageContext.request.contextPath}/ViewGuideServlet?id=<%= g.getGuideId() %>" class="guide-btn view">View Guide</a>
        </div>
      </div>
      <% } %>
    </div>
    <% } else { %>
    <div class="empty-state">
        <p>You haven't created any guides yet.</p>
        <p>Create your first guide to start receiving comments!</p>
    </div>
    <% } %>
</main>

<script>
// Simulate loading comment counts (in real implementation, this would be fetched from server)
document.addEventListener('DOMContentLoaded', function() {
    const commentCounts = document.querySelectorAll('[id^="comment-count-"]');
    commentCounts.forEach(element => {
        // Simulate random comment count between 0-15
        const count = Math.floor(Math.random() * 16);
        element.textContent = count;
    });
});
</script>

</body>
</html>
