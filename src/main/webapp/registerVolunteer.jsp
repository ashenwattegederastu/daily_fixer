<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Volunteer Signup - Daily Fixer</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <script>
        function validateForm() {
            let username = document.getElementById("username").value.trim();
            let email = document.getElementById("email").value.trim();
            let password = document.getElementById("password").value.trim();
            let agreement = document.getElementById("agreement").checked;

            let errorDiv = document.getElementById("errorMsg");
            errorDiv.innerHTML = "";

            if (username === "" || email === "" || password === "") {
                errorDiv.innerHTML = "All fields are required.";
                return false;
            }
            if (!agreement) {
                errorDiv.innerHTML = "You must agree to the terms before proceeding.";
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
<div class="login-wrapper">
    <div class="login-card">
        <h2>Volunteer Signup</h2>

        <c:if test="${not empty error}">
            <div class="error-msg">${error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/registerVolunteer" method="post" onsubmit="return validateForm()">
            <div class="input-field">
                <label>First Name</label>
                <input type="text" name="firstName" required>
            </div>
            <div class="input-field">
                <label>Last Name</label>
                <input type="text" name="lastName" required>
            </div>
            <div class="input-field">
                <label>Username</label>
                <input type="text" id="username" name="username" required>
            </div>
            <div class="input-field">
                <label>Email</label>
                <input type="email" id="email" name="email" required>
            </div>
            <div class="input-field">
                <label>Password</label>
                <input type="password" id="password" name="password" required>
            </div>
            <div class="input-field">
                <label>Phone Number</label>
                <input type="text" name="phone">
            </div>
            <div class="input-field">
                <label>City</label>
                <select name="city" required>
                    <option value="">Select City</option>
                    <option>Colombo</option>
                    <option>Kandy</option>
                    <option>Galle</option>
                    <option>Matara</option>
                    <option>Kurunegala</option>
                    <option>Negombo</option>
                    <option>Jaffna</option>
                    <option>Anuradhapura</option>
                    <option>Trincomalee</option>
                    <option>Batticaloa</option>
                    <option>Badulla</option>
                    <option>Rathnapura</option>
                    <option>Kalutara</option>
                    <option>Hambantota</option>
                    <option>Polonnaruwa</option>
                    <option>Ampara</option>
                    <option>Vavuniya</option>
                </select>
            </div>
            <div class="input-field">
                <label>Expertise</label>
                <input type="text" name="expertise" required>
            </div>
            <div class="input-field">
                <label>
                    <input type="checkbox" id="agreement" name="agreement">
                    I confirm I will not misuse the platform or upload false material.
                </label>
            </div>

            <div id="errorMsg" class="error-msg" style="color:red; margin-bottom:10px;"></div>

            <button type="submit" class="login-btn">Register</button>
            <p class="note">Already have an account? <a href="${pageContext.request.contextPath}/login.jsp">Login</a></p>
        </form>
    </div>
</div>
<script src="${pageContext.request.contextPath}/assets/js/password-toggle.js"></script>
</body>
</html>
