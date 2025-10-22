<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.dailyfixer.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - DailyFixer</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/login.css">
</head>
<body>

<div class="login-container">
    <div class="login-card">
        <!-- Added logo/branding section -->
        <div class="login-header">
            <h1 class="login-title">DailyFixer</h1>
            <p class="login-subtitle">Welcome back</p>
        </div>

        <!-- Improved message styling with better visual hierarchy -->
        <% String success = (String) session.getAttribute("successMsg");
            if (success != null) { %>
        <div class="alert alert-success"><%= success %></div>
        <% session.removeAttribute("successMsg"); } %>

        <% String loginError = (String) request.getAttribute("loginError");
            if (loginError != null) { %>
        <div class="alert alert-error"><%= loginError %></div>
        <% } %>

        <form method="post" action="login" class="login-form">
            <div class="form-group">
                <label for="username" class="form-label">Username</label>
                <input
                        type="text"
                        id="username"
                        name="username"
                        class="form-input"
                        placeholder="Enter your username"
                        required>
            </div>

            <div class="form-group">
                <label for="password" class="form-label">Password</label>
                <input
                        type="password"
                        id="password"
                        name="password"
                        class="form-input"
                        placeholder="Enter your password"
                        required>
            </div>

            <!-- Improved button styling -->
            <button type="submit" class="login-btn">Sign In</button>
        </form>

        <!-- Better organized footer links with improved styling -->
        <div class="login-footer">
            <p class="footer-text">
                Don't have an account?
                <a href="${pageContext.request.contextPath}/preliminarySignup.jsp" class="footer-link">Create one</a>
            </p>
            <p class="footer-text">
                <a href="#" class="footer-link">Forgot your password?</a>
            </p>
            <p class="footer-text">
                <a href="${pageContext.request.contextPath}/index.jsp" class="footer-link-secondary">← Back to Home</a>
            </p>
        </div>
    </div>
</div>

</body>
</html>
