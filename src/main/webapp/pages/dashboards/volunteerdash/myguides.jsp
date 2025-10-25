<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,com.dailyfixer.dao.GuideDAO,com.dailyfixer.model.Guide" %>
<%@ page import="com.dailyfixer.model.User" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%
  User currentUser = (User) session.getAttribute("currentUser");
  if (currentUser == null || !"volunteer".equalsIgnoreCase(currentUser.getRole())) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
  }

  int userId = currentUser.getUserId();
  GuideDAO dao = new GuideDAO();
  List<Guide> myGuides = dao.getGuidesByVolunteer(userId);
  request.setAttribute("myGuides", myGuides);
%>

<html>
<head>
  <title>My Guides - DailyFixer</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/deliverdashmain.css">
  <style>
    .dashboard {
      padding: 20px;
      animation: fadeIn 0.5s ease-in-out;
    }

    .dashboard h2 {
      margin-bottom: 20px;
      font-family: 'Arial', sans-serif;
      color: #003366;
    }

    .guide-container {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
      gap: 20px;
    }

    .guide-card {
      background: white;
      border-radius: 12px;
      padding: 15px;
      box-shadow: 0 3px 8px rgba(0,0,0,0.1);
      text-align: center;
      transition: transform 0.2s ease;
    }

    .guide-card:hover {
      transform: translateY(-5px);
    }

    .guide-card img {
      width: 100%;
      height: 150px;
      object-fit: cover;
      border-radius: 8px;
      margin-bottom: 10px;
    }

    .guide-card a.title-link {
      display: block;
      font-weight: bold;
      color: #003366;
      text-decoration: none;
      font-size: 18px;
      margin-bottom: 5px;
    }

    .guide-card a.title-link:hover {
      text-decoration: underline;
    }

    .btn-group {
      display: flex;
      justify-content: center;
      gap: 10px;
      margin-top: 10px;
    }

    .guide-btn {
      padding: 8px 15px;
      border-radius: 8px;
      color: white;
      font-weight: bold;
      text-decoration: none;
      transition: 0.2s;
    }

    .guide-btn.edit { background: #ffa500; }
    .guide-btn.edit:hover { background: #e59400; }

    .guide-btn.delete { background: #ff4c4c; }
    .guide-btn.delete:hover { background: #e04343; }

    .add-guide-btn {
      display: inline-block;
      margin-bottom: 20px;
      padding: 10px 20px;
      background: #7c8cff;
      color: white;
      font-weight: bold;
      border-radius: 10px;
      text-decoration: none;
      transition: 0.2s;
    }

    .add-guide-btn:hover {
      background: #6b7aff;
    }
  </style>
</head>
<body>

<header>
  <div class="navbar">
    <div class="logo">DailyFixer</div>
    <ul class="nav-links">
      <li><a href="${pageContext.request.contextPath}">Home</a></li>
      <li><a href="${pageContext.request.contextPath}/logout">Log Out</a></li>
    </ul>
  </div>

  <div class="subnav">
    <div class="store-name">Volunteer Dashboard</div>
    <ul>
      <li><a href="${pageContext.request.contextPath}/pages/dashboards/volunteerdash/volunteerdashmain.jsp" class="active">Dashboard</a></li>

      <li><a href="#">My Guides</a></li>
      <li><a href="${pageContext.request.contextPath}/pages/dashboards/volunteerdash/myProfile.jsp">Profile</a></li>

    </ul>
  </div>
</header>

<div class="container">
  <main class="dashboard">
    <h2>My Guides</h2>
    <a href="addGuide.jsp" class="add-guide-btn">+ Add New Guide</a>

    <c:choose>
      <c:when test="${myGuides != null && !myGuides.isEmpty()}">
    <div class="guide-container">
      <c:forEach var="g" items="${myGuides}">
      <div class="guide-card">
        <img src="${pageContext.request.contextPath}/ImageServlet?id=${g.guideId}" alt="<c:out value='${g.title}'/>">
        <a href="${pageContext.request.contextPath}/ViewGuideServlet?id=${g.guideId}" class="title-link"><c:out value="${g.title}"/></a>
        <div class="btn-group">
          <a href="${pageContext.request.contextPath}/EditGuideServlet?id=${g.guideId}" class="guide-btn edit">Edit</a>
          <a href="${pageContext.request.contextPath}/DeleteGuideServlet?id=${g.guideId}" class="guide-btn delete" onclick="return confirm('Are you sure you want to delete this guide?');">Delete</a>
        </div>
      </div>
      </c:forEach>
    </div>
      </c:when>
      <c:otherwise>
    <p>You haven't added any guides yet.</p>
      </c:otherwise>
    </c:choose>
  </main>
</div>

</body>
</html>
