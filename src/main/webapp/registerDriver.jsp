<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Driver Signup | DailyFixer</title>
    <style>
        body {
            font-family: "Poppins", sans-serif;
            background: #f0f4f8;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .signup-container {
            background: #fff;
            padding: 30px 40px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            width: 400px;
        }

        h2 {
            text-align: center;
            color: #007BFF;
            margin-bottom: 25px;
        }

        input[type=text], input[type=password], input[type=email], input[type=tel] {
            width: 100%;
            padding: 10px;
            margin: 6px 0 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }

        button {
            width: 100%;
            background-color: #007BFF;
            color: white;
            padding: 10px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }

        button:hover {
            background-color: #0056b3;
        }

        .error {
            color: red;
            font-size: 13px;
            margin-bottom: 8px;
        }
    </style>
    <script>
        function validateForm() {
            let pw = document.getElementById("password").value;
            let cpw = document.getElementById("confirmPassword").value;
            let email = document.getElementById("email").value;
            let phone = document.getElementById("phone_number").value;

            let errorMsg = "";

            if (!email.includes("@")) errorMsg += "Invalid email format.<br>";
            if (pw.length < 6) errorMsg += "Password must be at least 6 characters.<br>";
            if (pw !== cpw) errorMsg += "Passwords do not match.<br>";
            if (phone.length < 10) errorMsg += "Enter a valid phone number.<br>";

            document.getElementById("error").innerHTML = errorMsg;

            return errorMsg === "";
        }
    </script>
</head>
<body>
<div class="signup-container">
    <h2>Driver Signup</h2>
    <form action="RegisterDriverServlet" method="post" onsubmit="return validateForm()">
        <div id="error" class="error"></div>
        <input type="text" name="first_name" placeholder="First Name" required>
        <input type="text" name="last_name" placeholder="Last Name" required>
        <input type="text" name="username" placeholder="Username" required>
        <input type="email" name="email" id="email" placeholder="Email" required>
        <input type="tel" name="phone_number" id="phone_number" placeholder="Phone Number" required>
        <input type="text" name="city" placeholder="City" required>
        <input type="password" name="password" id="password" placeholder="Password" required>
        <input type="password" name="confirmPassword" id="confirmPassword" placeholder="Confirm Password" required>
        <button type="submit">Register as Driver</button>
    </form>
</div>
</body>
</html>
