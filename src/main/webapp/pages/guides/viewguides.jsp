<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="guides" value="${requestScope.guides}" />

<html>
<head>
  <title>All Guides - DailyFixer</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background: linear-gradient(to bottom, #ffffff, #c8d9ff);
      margin: 0;
      padding: 0;
      color: #333;
    }

    .navbar {
      background-color: #7c8cff;
      padding: 15px 30px;
      color: white;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    .navbar .logo {
      font-size: 22px;
      font-weight: bold;
    }

    .navbar a {
      color: white;
      text-decoration: none;
      margin-left: 20px;
      font-weight: bold;
    }

    .container {
      max-width: 1200px;
      margin: 30px auto;
      padding: 20px;
    }

    h2 {
      color: #003366;
      margin-bottom: 30px;
      font-size: 32px;
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

    .no-guides {
      text-align: center;
      padding: 50px;
      color: #666;
      font-size: 18px;
    }
  </style>
</head>
<body>

<div class="navbar">
  <div class="logo">DailyFixer</div>
  <div>
    <a href="${pageContext.request.contextPath}">Home</a>
  </div>
</div>

<div class="container">
  <h2>All Repair Guides</h2>

  <c:choose>
    <c:when test="${not empty guides}">
  <div class="guide-container">
    <c:forEach var="g" items="${guides}">
    <div class="guide-card">
      <img src="${pageContext.request.contextPath}/ImageServlet?id=${g.guideId}" alt="${g.title}">
      <a href="${pageContext.request.contextPath}/ViewGuideServlet?id=${g.guideId}" class="title-link"><c:out value="${g.title}"/></a>
    </div>
    </c:forEach>
  </div>
    </c:when>
    <c:otherwise>
  <div class="no-guides">
    <p>No guides available yet. Check back later!</p>
  </div>
    </c:otherwise>
  </c:choose>
</div>

</body>
</html>
