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
    <title>My Profile - Daily Fixer</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/deliverdashmain.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/profile.css">
</head>
<body>

<header>
    <!-- Main Navbar -->
    <nav class="navbar">
        <div class="logo">Daily Fixer</div>
        <ul class="nav-links">
            <li><a href="${pageContext.request.contextPath}">Home</a></li>
            <li><a href="${pageContext.request.contextPath}/LogoutServlet">Log Out</a></li>
        </ul>
    </nav>

    <!-- Subnav -->
    <nav class="subnav">
        <div class="store-name">User Dashboard</div>
        <ul>
            <li><a href="${pageContext.request.contextPath}/pages/dashboards/userdash/userdashmain.jsp">Dashboard</a></li>
            <li><a href="#" class="active">Profile</a></li>
        </ul>
    </nav>
</header>

<div class="container">
    <main class="dashboard">
        <h2>My Profile</h2>
        <p class="subtitle">View and manage your account information</p>

        <div class="profile-card">
            <div class="profile-image">
                <img src="${pageContext.request.contextPath}/assets/images/default-profile.png" alt="Profile Picture">
                <h2>${sessionScope.currentUser.firstName} ${sessionScope.currentUser.lastName}</h2>
                <p class="role">(${sessionScope.currentUser.role})</p>
            </div>

            <div class="profile-details">
                <table>
                    <tr><th>User ID:</th><td>${sessionScope.currentUser.userId}</td></tr>
                    <tr><th>First Name:</th><td>${sessionScope.currentUser.firstName}</td></tr>
                    <tr><th>Last Name:</th><td>${sessionScope.currentUser.lastName}</td></tr>
                    <tr><th>Username:</th><td>${sessionScope.currentUser.username}</td></tr>
                    <tr><th>Email:</th><td>${sessionScope.currentUser.email}</td></tr>
                    <tr><th>Phone:</th><td>${sessionScope.currentUser.phoneNumber}</td></tr>
                    <tr><th>City:</th><td>${sessionScope.currentUser.city}</td></tr>
                    <tr><th>Role:</th><td>${sessionScope.currentUser.role}</td></tr>
                </table>

                <div class="profile-buttons">
                    <form action="${pageContext.request.contextPath}/resetPassword.jsp" method="get">
                        <button type="submit" class="btn reset">Reset Password</button>
                    </form>
                    <form action="${pageContext.request.contextPath}/editProfile.jsp" method="get">
                        <button type="submit" class="btn edit">Edit Account Info</button>
                    </form>
                </div>
            </div>
        </div>
    </main>
</div>

</body>
</html>
