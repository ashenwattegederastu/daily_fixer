<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register - DailyFixer</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        /* Removed background image, using gradient instead */
        .register-hero {
            position: relative;
            background: linear-gradient(to bottom, #ffffff, #c8d9ff);
            min-height: calc(100vh - 140px);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
            box-sizing: border-box;
            overflow: auto;
        }

        /* Removed overlay pseudo-element */

        /* Floating registration card */
        .register-card {
            position: relative;
            background: #fff;
            padding: 36px 28px;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(124, 140, 255, 0.15);
            max-width: 520px;
            width: 100%;
            z-index: 2;
            margin: 20px;
            animation: slideUp 0.5s ease-out;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .register-card h2 {
            text-align: center;
            font-size: 28px;
            margin-bottom: 24px;
            color: #1b2647;
            font-weight: 600;
        }

        .input-field {
            display: flex;
            flex-direction: column;
            margin-bottom: 16px;
        }

        .input-field label {
            font-weight: 600;
            margin-bottom: 8px;
            color: #6b77cf;
            font-size: 14px;
        }

        /* Updated input styling to match theme */
        .input-field input, .input-field select {
            padding: 12px 14px;
            border-radius: 8px;
            border: 1.5px solid #e0e8ff;
            font-size: 15px;
            outline: none;
            transition: all 0.2s ease-in-out;
            background: #f8faff;
            color: #333;
        }

        .input-field input:focus, .input-field select:focus {
            border-color: #7c8cff;
            background: #fff;
            box-shadow: 0 0 0 3px rgba(124, 140, 255, 0.1);
        }

        /* Updated button to use theme color */
        .login-btn {
            background: #7c8cff;
            color: #fff;
            border: none;
            padding: 14px;
            font-size: 16px;
            font-weight: 600;
            border-radius: 8px;
            cursor: pointer;
            width: 100%;
            transition: all 0.2s ease-in-out;
            margin-top: 8px;
        }
        .login-btn:hover {
            background: #6b7de8;
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(124, 140, 255, 0.3);
        }

        .note {
            text-align: center;
            margin-top: 16px;
            font-size: 14px;
            color: #666;
        }

        .note a {
            color: #7c8cff;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.2s;
        }

        .note a:hover {
            color: #6b7de8;
        }

        /* Updated error message styling */
        .error {
            color: #e74c3c;
            font-size: 0.85rem;
            margin-top: 6px;
            font-weight: 500;
        }

        /* Server error alert */
        .server-error {
            background: #ffe0e0;
            border: 1px solid #e74c3c;
            color: #c0392b;
            padding: 12px 14px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
            font-weight: 500;
            animation: slideDown 0.3s ease-out;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Responsive tweaks */
        @media screen and (max-width: 900px) {
            .register-card { padding: 28px 18px; }
            .register-hero { min-height: calc(100vh - 120px); padding: 32px 16px; }
        }

        @media screen and (max-width: 420px) {
            .register-card { padding: 20px 14px; margin: 12px; }
            .register-hero { min-height: calc(100vh - 100px); padding: 24px 12px; }
            .register-card h2 { font-size: 24px; }
        }
    </style>
</head>
<body>
<div class="register-hero">
    <div class="register-card">
        <h2>Create User Account</h2>

        <% String serverError = (String) request.getAttribute("errorMsg"); %>
        <% if (serverError != null) { %>
        <!-- Updated error message styling -->
        <div class="server-error"><%= serverError %></div>
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
                <div class="input-field">

                    <select name="city" id="city">
                        <option value="">-- Select City --</option>
                        <option>Colombo</option>
                        <option>Kandy</option>
                        <option>Galle</option>
                        <option>Jaffna</option>
                        <option>Negombo</option>
                        <option>Matara</option>
                        <option>Trincomalee</option>
                        <option>Anuradhapura</option>
                        <option>Kurunegala</option>
                        <option>Ratnapura</option>
                        <option>Badulla</option>
                        <option>Hambantota</option>
                        <option>Puttalam</option>
                        <option>Polonnaruwa</option>
                        <option>Nuwara Eliya</option>
                        <option>Vavuniya</option>
                        <option>Mannar</option>
                        <option>Mullaitivu</option>
                        <option>Kalutara</option>
                        <option>Batticaloa</option>
                        <option>Ampara</option>
                        <option>Monaragala</option>
                        <option>Kegalle</option>
                        <option>Matalawa</option>
                    </select>
                    <div id="cityError" class="error"></div>
                </div>

                <div id="cityError" class="error"></div>
            </div>

            <button type="submit" class="login-btn">Register</button>
        </form>

        <p class="note">Already have an account? <a href="login.jsp">Login here</a></p>
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

        // Phone number validation: exactly 10 digits
        const phoneVal = f('phone').replace(/\D/g, ''); // remove non-digit characters
        if(!phoneVal){
            document.getElementById('phoneError').textContent = 'Phone number required';
            hasError = true;
        } else if(phoneVal.length !== 10) {
            document.getElementById('phoneError').textContent = 'Phone must be exactly 10 digits';
            hasError = true;
        }

        // Email validation: required + valid format
        const emailVal = f('email');
        if (!emailVal) {
            document.getElementById('emailError').textContent = 'Email required';
            hasError = true;
        } else {
            // Simple regex for basic email format check
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(emailVal)) {
                document.getElementById('emailError').textContent = 'Invalid email format';
                hasError = true;
            }
        }


        if(hasError) e.preventDefault();
    });
</script>
<script src="${pageContext.request.contextPath}/assets/js/password-toggle.js"></script>
</body>
</html>
