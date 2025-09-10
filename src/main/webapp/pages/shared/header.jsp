<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="true" %>

<header>
    <!-- Main Navbar -->
    <nav class="navbar">
        <div class="logo">Daily Fixer</div>
        <ul class="nav-links">
            <li><a href="${pageContext.request.contextPath}/index.jsp" class="${page == 'home' ? 'active' : ''}">Home</a></li>
            <li><a href="#about" class="${page == 'about' ? 'active' : ''}">About</a></li>
            <li><a href="#services" class="${page == 'services' ? 'active' : ''}">Services</a></li>
            <li>
                <c:choose>
                <c:when test="${not empty sessionScope.user}">
                <a href="${pageContext.request.contextPath}/pages/dashboards/${sessionScope.user.usertype}dash/${sessionScope.user.usertype}dashmain.jsp">Dashboard</a>
            <li><a href="${pageContext.request.contextPath}/LogoutServlet">Logout</a></li>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/pages/shared/login.jsp">Log in</a>
            </c:otherwise>
            </c:choose>
            </li>
        </ul>
    </nav>

    <!-- Subnav -->
    <div class="sub-nav">
        <a href="${pageContext.request.contextPath}/pages/DiagnosticTool/diagnostic.jsp" class="${page == 'diagnostic' ? 'active' : ''}">Diagnose Now</a>
        <a href="${pageContext.request.contextPath}/pages/findtechnician/findtechmain.jsp" class="${page == 'findtech' ? 'active' : ''}">Find a Technician</a>
        <a href="${pageContext.request.contextPath}/pages/guide_view/guidehome.jsp" class="${page == 'guides' ? 'active' : ''}">View Repair Guides</a>
        <a href="${pageContext.request.contextPath}/pages/store/store.jsp" class="${page == 'store' ? 'active' : ''}">Stores</a>
    </div>

    <!-- Include CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/navbar.css">
</header>
