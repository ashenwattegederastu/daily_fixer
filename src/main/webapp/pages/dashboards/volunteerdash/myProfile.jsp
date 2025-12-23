<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page import="com.dailyfixer.model.User" %>

<%
    User user = (User) session.getAttribute("currentUser");
    if (user == null || user.getRole() == null || !"volunteer".equalsIgnoreCase(user.getRole().trim())) {
        response.sendRedirect(request.getContextPath() + "/pages/shared/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile | Daily Fixer</title>
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

    /* Profile Card */
    .profile-card {
        background: #fff;
        border-radius: 12px;
        padding: 30px;
        box-shadow: var(--shadow-sm);
        border: 1px solid rgba(0,0,0,0.1);
        margin-top: 20px;
    }

    .profile-header {
        display: flex;
        align-items: center;
        margin-bottom: 30px;
        padding-bottom: 20px;
        border-bottom: 2px solid var(--panel-color);
    }

    .profile-image {
        width: 80px;
        height: 80px;
        border-radius: 50%;
        background: var(--panel-color);
        display: flex;
        align-items: center;
        justify-content: center;
        margin-right: 20px;
        font-size: 2em;
        color: var(--accent);
    }

    .profile-info h3 {
        font-size: 1.5em;
        margin-bottom: 5px;
        color: var(--text-dark);
    }

    .profile-info .role {
        color: var(--text-secondary);
        font-weight: 500;
    }

    .profile-details {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
        gap: 20px;
    }

    .detail-section {
        background: var(--panel-color);
        padding: 20px;
        border-radius: 8px;
        border-left: 4px solid var(--accent);
    }

    .detail-section h4 {
        margin-bottom: 15px;
        color: var(--text-dark);
        font-size: 1.1em;
    }

    .detail-row {
        display: flex;
        justify-content: space-between;
        margin-bottom: 10px;
        padding-bottom: 8px;
        border-bottom: 1px solid rgba(0,0,0,0.1);
    }

    .detail-row:last-child {
        border-bottom: none;
        margin-bottom: 0;
    }

    .detail-label {
        font-weight: 500;
        color: var(--text-secondary);
    }

    .detail-value {
        color: var(--text-dark);
        font-weight: 500;
    }

    .profile-actions {
        margin-top: 30px;
        display: flex;
        gap: 15px;
        flex-wrap: wrap;
    }

    .btn {
        padding: 12px 24px;
        border-radius: 8px;
        color: white;
        font-weight: 600;
        text-decoration: none;
        transition: all 0.2s;
        border: none;
        cursor: pointer;
        font-size: 0.9em;
        box-shadow: var(--shadow-sm);
    }

    .btn:hover {
        transform: translateY(-2px);
        box-shadow: var(--shadow-md);
    }

    .btn.reset {
        background: var(--accent);
    }
    .btn.reset:hover {
        background: #7a85e6;
    }

    .btn.edit {
        background: #28a745;
    }
    .btn.edit:hover {
        background: #218838;
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
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/volunteerdash/guideComments.jsp">Guide Comments</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/volunteerdash/notifications.jsp">Notifications</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/volunteerdash/addGuide.jsp">Add Guide</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/volunteerdash/myProfile.jsp" class="active">My Profile</a></li>
    </ul>
</aside>

<div class="container">
    <h2>My Profile</h2>
    <p style="color: var(--text-secondary); margin-bottom: 20px;">View and manage your volunteer account information</p>

    <div class="profile-card">
        <div class="profile-header">
            <div class="profile-image">
                👤
            </div>
            <div class="profile-info">
                <h3>${sessionScope.currentUser.firstName} ${sessionScope.currentUser.lastName}</h3>
                <p class="role">Volunteer</p>
            </div>
        </div>

        <div class="profile-details">
            <div class="detail-section">
                <h4>Personal Information</h4>
                <div class="detail-row">
                    <span class="detail-label">User ID:</span>
                    <span class="detail-value">${sessionScope.currentUser.userId}</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">First Name:</span>
                    <span class="detail-value">${sessionScope.currentUser.firstName}</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Last Name:</span>
                    <span class="detail-value">${sessionScope.currentUser.lastName}</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Username:</span>
                    <span class="detail-value">${sessionScope.currentUser.username}</span>
                </div>
            </div>

            <div class="detail-section">
                <h4>Contact Information</h4>
                <div class="detail-row">
                    <span class="detail-label">Email:</span>
                    <span class="detail-value">${sessionScope.currentUser.email}</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Phone:</span>
                    <span class="detail-value">${sessionScope.currentUser.phoneNumber}</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">City:</span>
                    <span class="detail-value">${sessionScope.currentUser.city}</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Role:</span>
                    <span class="detail-value">${sessionScope.currentUser.role}</span>
                </div>
            </div>
        </div>

        <div class="profile-actions">
            <form action="${pageContext.request.contextPath}/resetPassword.jsp" method="get" style="display: inline;">
                <button type="submit" class="btn reset">Reset Password</button>
            </form>
            <form action="${pageContext.request.contextPath}/editProfile.jsp" method="get" style="display: inline;">
                <button type="submit" class="btn edit">Edit Account Info</button>
            </form>
        </div>
    </div>
</div>

</body>
</html>
