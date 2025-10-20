<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register - DailyFixer</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        /* Adjust hero to account for fixed header and avoid top/bottom cutoff */
        .register-hero {
            position: relative;
            background: url('assets/images/pictures/living room.jpg') no-repeat center center;
            background-size: cover;
            /* subtract approximate header+subnav height (adjust if your header is taller) */
            min-height: calc(100vh - 140px);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;          /* safe space top/bottom */
            box-sizing: border-box;
            overflow: auto;              /* allow scrolling on small screens */
        }

        .register-hero::after {
            content: '';
            position: absolute;
            inset: 0;
            background: rgba(0,0,0,0.32);
            pointer-events: none;
        }

        /* Floating registration card */
        .register-card {
            position: relative;
            background: #fff;
            padding: 36px 28px;
            border-radius: 12px;
            box-shadow: 0 12px 30px rgba(0,0,0,0.35);
            max-width: 520px;
            width: 100%;
            z-index: 2;
            margin: 20px; /* keeps distance on very small screens */
        }

        .register-card h2 {
            text-align: center;
            font-size: 28px;
            margin-bottom: 18px;
            color: #222;
        }

        .input-field {
            display: flex;
            flex-direction: column;
            margin-bottom: 12px;
        }

        .input-field label {
            font-weight: 600;
            margin-bottom: 6px;
            color: #444;
        }

        .input-field input, .input-field select {
            padding: 12px 14px;
            border-radius: 8px;
            border: 1px solid #ccc;
            font-size: 15px;
            outline: none;
            transition: 0.15s ease-in-out;
        }

        .input-field input:focus, .input-field select:focus {
            border-color: #3f51ff;
            box-shadow: 0 6px 18px rgba(63,81,255,0.12);
        }

        .login-btn {
            background: #0077cc;
            color: #fff;
            border: none;
            padding: 14px;
            font-size: 16px;
            border-radius: 8px;
            cursor: pointer;
            width: 100%;
            transition: background 0.2s ease-in-out, transform 0.08s;
        }
        .login-btn:hover { background: #005fa3; transform: translateY(-1px); }

        .note { text-align: center; margin-top: 12px; font-size: 14px; color: #666; }

        /* Inline error messages */
        .error { color: #b00020; font-size: 0.9rem; margin-top: 6px; }

        /* Responsive tweaks */
        @media screen and (max-width: 900px) {
            .register-card { padding: 28px 18px; }
            .register-hero { min-height: calc(100vh - 120px); padding: 32px 16px; }
        }

        @media screen and (max-width: 420px) {
            .register-card { padding: 20px 14px; margin: 12px; }
            .register-hero { min-height: calc(100vh - 100px); padding: 24px 12px; }
        }
    </style>
</head>
<body>
<div class="register-hero">
    <div class="register-card">
        <h2>Register (User)</h2>

        <% String serverError = (String) request.getAttribute("errorMsg"); %>
        <% if (serverError != null) { %>
        <div class="error"><%= serverError %></div>
        <% } %>

        <form id="registerForm" method="post" action="registerUser">
            <div class="input-field">
                <label>First Name</label>
                <input type="text" name="firstName" id="firstName">
                <div id="firstNameError" class="error"></div>
            </div>

            <div class="input-field">
                <label>Last Name</label>
                <input type="text" name="lastName" id="lastName">
                <div id="lastNameError" class="error"></div>
            </div>

            <div class="input-field">
                <label>Username</label>
                <input type="text" name="username" id="username">
                <div id="usernameError" class="error"></div>
            </div>

            <div class="input-field">
                <label>Email</label>
                <input type="email" name="email" id="email">
                <div id="emailError" class="error"></div>
            </div>

            <div class="input-field">
                <label>Password</label>
                <input type="password" name="password" id="password">
                <div id="passwordError" class="error"></div>
            </div>

            <div class="input-field">
                <label>Confirm Password</label>
                <input type="password" name="confirmPassword" id="confirmPassword">
                <div id="confirmPasswordError" class="error"></div>
            </div>

            <div class="input-field">
                <label>Phone</label>
                <input type="text" name="phone" id="phone">
                <div id="phoneError" class="error"></div>
            </div>

            <div class="input-field">
                <label>City</label>
                <select name="city" id="city">
                    <option value="">-- Select City --</option>
                    <option>Colombo</option>
                    <option>Kandy</option>
                    <option>Galle</option>
                </select>
                <div id="cityError" class="error"></div>
            </div>

            <button type="submit" class="login-btn">Register</button>
        </form>

        <p class="note">Already have an account? <a href="login.jsp">Login</a></p>
    </div>
</div>

<script>
    const form = document.getElementById('registerForm');
    form.addEventListener('submit', e => {
        document.querySelectorAll('.error').forEach(el => el.textContent = '');
        let hasError = false;
        const f = id => document.getElementById(id).value.trim();

        if(!f('firstName')){ document.getElementById('firstNameError').textContent = 'First name required'; hasError = true;}
        if(!f('lastName')){ document.getElementById('lastNameError').textContent = 'Last name required'; hasError = true;}
        if(!f('username')){ document.getElementById('usernameError').textContent = 'Username required'; hasError = true;}
        if(!f('email')){ document.getElementById('emailError').textContent = 'Email required'; hasError = true;}
        if(f('password').length < 6){ document.getElementById('passwordError').textContent = 'Min 6 chars'; hasError = true;}
        if(f('password') !== f('confirmPassword')){ document.getElementById('confirmPasswordError').textContent = 'Passwords do not match'; hasError = true;}
        if(!f('city')){ document.getElementById('cityError').textContent = 'City required'; hasError = true;}

        if(hasError) e.preventDefault();
    });
</script>
</body>
</html>
