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

            <!-- User greeting / login-logout -->
            <c:choose>
                <c:when test="${not empty sessionScope.currentUser}">
                    <li>
                        <a href="${pageContext.request.contextPath}/pages/dashboards/${sessionScope.currentUser.role}dash/${sessionScope.currentUser.role}dashmain.jsp">
                            Hi, ${sessionScope.currentUser.firstName}
                        </a>
                    </li>
                    <li><a href="${pageContext.request.contextPath}/logout">Logout</a></li>
                </c:when>
                <c:otherwise>
                    <li><a href="${pageContext.request.contextPath}/login.jsp">Log in</a></li>
                    <li><a href="${pageContext.request.contextPath}/preliminarySignup.jsp">Sign Up</a></li>
                </c:otherwise>
            </c:choose>
        </ul>
    </nav>

    <!-- Subnav -->
    <div class="sub-nav">
        <a href="${pageContext.request.contextPath}/diagnostic.jsp" class="${page == 'diagnostic' ? 'active' : ''}">Diagnose Now</a>
        <a href="${pageContext.request.contextPath}/findtech.jsp" class="${page == 'findtech' ? 'active' : ''}">Find a Technician</a>
        <a href="${pageContext.request.contextPath}/viewguides.jsp" class="${page == 'guides' ? 'active' : ''}">View Repair Guides</a>
        <a href="${pageContext.request.contextPath}/store.jsp" class="${page == 'store' ? 'active' : ''}">Stores</a>
    </div>

    <!-- Include CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/navbar.css">
</header>
