<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register Technician - DailyFixer</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            background: linear-gradient(135deg, #ffffff 0%, #c8d9ff 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .signup-wrapper {
            width: 100%;
            max-width: 700px;
            animation: slideIn 0.5s ease-out;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 10px 40px rgba(124, 140, 255, 0.15);
            padding: 40px;
        }

        .card h2 {
            font-size: 28px;
            font-weight: 700;
            color: #1b2647;
            margin-bottom: 8px;
            letter-spacing: -0.5px;
        }

        .card-subtitle {
            font-size: 14px;
            color: #666;
            margin-bottom: 28px;
        }

        /* Updated error message styling to match theme */
        #errorMsg {
            background: #ffe0e0;
            color: #c41e3a;
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
            line-height: 1.5;
            border-left: 4px solid #c41e3a;
            display: none;
        }

        #errorMsg:not(:empty) {
            display: block;
        }

        .section-title {
            font-size: 13px;
            font-weight: 700;
            color: #7c8cff;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-top: 24px;
            margin-bottom: 16px;
        }

        .section-title:first-of-type {
            margin-top: 0;
        }

        .input-row {
            display: flex;
            gap: 16px;
            margin-bottom: 16px;
        }

        .input-row > div {
            flex: 1;
        }

        label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: #333;
            margin-bottom: 6px;
        }

        /* Updated input styling to match login page theme */
        .small,
        select {
            width: 100%;
            padding: 11px 14px;
            border: 1.5px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            font-family: inherit;
            background: #f8f9ff;
            color: #333;
            transition: all 0.2s ease;
        }

        .small:focus,
        select:focus {
            outline: none;
            border-color: #7c8cff;
            background: white;
            box-shadow: 0 0 0 3px rgba(124, 140, 255, 0.1);
        }

        .small::placeholder {
            color: #999;
        }

        /* Updated button styling to match theme */
        .login-btn {
            width: 100%;
            padding: 12px 16px;
            border: none;
            border-radius: 8px;
            background: linear-gradient(135deg, #7c8cff 0%, #6b7ce8 100%);
            color: white;
            font-weight: 600;
            font-size: 15px;
            cursor: pointer;
            margin-top: 24px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(124, 140, 255, 0.3);
        }

        .login-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(124, 140, 255, 0.4);
        }

        .login-btn:active {
            transform: translateY(0);
        }

        @media (max-width: 600px) {
            .card {
                padding: 24px;
            }

            .card h2 {
                font-size: 24px;
            }

            .input-row {
                flex-direction: column;
                gap: 0;
            }
        }
    </style>
</head>
<body>

<div class="signup-wrapper">
    <div class="card">
        <h2>Technician Account</h2>
        <p class="card-subtitle">Register to start accepting jobs</p>

        <div id="errorMsg"></div>

        <form method="post" action="registerTechnician" onsubmit="return validateForm();">
            <div class="section-title">Personal Details</div>

            <div class="input-row">
                <div>
                    <label>First Name</label>
                    <input class="small" type="text" name="firstName" id="firstName" required>
                </div>
                <div>
                    <label>Last Name</label>
                    <input class="small" type="text" name="lastName" id="lastName" required>
                </div>
            </div>

            <div class="input-row">
                <div>
                    <label>Username</label>
                    <input class="small" type="text" name="username" id="username" required>
                </div>
                <div>
                    <label>Email</label>
                    <input class="small" type="email" name="email" id="email" required>
                </div>
            </div>

            <div class="input-row">
                <div>
                    <label>Password</label>
                    <input class="small" type="password" name="password" id="password" required>
                </div>
                <div>
                    <label>Confirm Password</label>
                    <input class="small" type="password" name="confirmPassword" id="confirmPassword" required>
                </div>
            </div>

            <div class="section-title">Contact Information</div>

            <div class="input-row">
                <div>
                    <label>Phone Number</label>
                    <input class="small" type="text" name="phone" id="phone">
                </div>
                <div>
                    <label>City</label>
                    <select name="city" id="city" required>
                        <option value="">-- Select city --</option>
                        <%
                            String[] cities = {"Colombo","Kandy","Galle","Jaffna","Kurunegala","Matara","Trincomalee","Batticaloa","Negombo","Anuradhapura","Polonnaruwa","Badulla","Ratnapura","Puttalam","Kilinochchi","Mannar","Hambantota"};
                            for (String c : cities) {
                        %>
                        <option value="<%=c%>"><%=c%></option>
                        <% } %>
                    </select>
                </div>
            </div>

            <button type="submit" class="login-btn">Register Technician</button>
            <p class="note">Already have an account? <a href="login.jsp">Login here</a></p>
        </form>
    </div>
</div>

<script>
    function validateForm(){
        var errorMsg = [];
        var firstName = document.getElementById('firstName').value.trim();
        var lastName = document.getElementById('lastName').value.trim();
        var username = document.getElementById('username').value.trim();
        var email = document.getElementById('email').value.trim();
        var password = document.getElementById('password').value;
        var confirmPassword = document.getElementById('confirmPassword').value;
        var city = document.getElementById('city').value;

        if(!firstName) errorMsg.push("First Name is required.");
        if(!lastName) errorMsg.push("Last Name is required.");
        if(!username) errorMsg.push("Username is required.");
        if(!email) errorMsg.push("Email is required.");
        if(!password) errorMsg.push("Password is required.");
        if(password && password.length < 6) errorMsg.push("Password must be at least 6 characters.");
        if(password !== confirmPassword) errorMsg.push("Passwords do not match.");
        if(!city) errorMsg.push("City is required.");

        if(errorMsg.length > 0){
            document.getElementById('errorMsg').innerHTML = errorMsg.join("<br>");
            return false;
        }
        return true;
    }
</script>
<script src="${pageContext.request.contextPath}/assets/js/password-toggle.js"></script>

</body>
</html>
