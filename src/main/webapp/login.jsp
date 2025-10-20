<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.dailyfixer.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login - DailyFixer</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css"> <!-- Update path -->
</head>
<body>

<div class="login-wrapper">
    <div class="login-card">
        <h2>Login</h2>

        <%-- Success message --%>
        <% String success = (String) session.getAttribute("successMsg");
            if (success != null) { %>
        <div style="color: green; text-align:center; margin-bottom:10px;"><%= success %></div>
        <% session.removeAttribute("successMsg"); } %>

        <%-- Error message --%>
        <% String loginError = (String) request.getAttribute("loginError");
            if (loginError != null) { %>
        <div style="color: red; text-align:center; margin-bottom:10px;"><%= loginError %></div>
        <% } %>

        <form method="post" action="login">
            <div class="input-field">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" placeholder="Enter your username" required>
            </div>

            <div class="input-field">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" placeholder="Enter your password" required>
            </div>

            <button type="submit" class="login-btn">Login</button>
        </form>

        <p class="note">
            Don’t have an account? <a href="registerUser.jsp">Register here</a><br>
            Forgot Password?<br>
            Go Back Home <a href="index.jsp">Home</a>
        </p>
    </div>
</div>

</body>
</html>
