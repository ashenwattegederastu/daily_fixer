<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Sign Up - Daily Fixer</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            /* Smooth gradient with subtle noise-like blend */
            background: linear-gradient(135deg, #7c8cff 0%, #a9bbff 50%, #d7e3ff 100%);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .signup-choices-container {
            text-align: center;
            padding-top: 100px;
            flex-grow: 1;
        }

        .signup-choices-container h2 {
            font-size: 2rem;
            margin-bottom: 40px;
            color: #222;
        }

        .role-cards {
            display: flex;
            gap: 30px;
            flex-wrap: wrap;
            justify-content: center;
        }

        .role-card {
            background: rgba(255, 255, 255, 0.85);
            color: #333;
            padding: 30px 20px;
            border-radius: 16px;
            text-align: center;
            cursor: pointer;
            transition: transform 0.3s, box-shadow 0.3s;
            width: 180px;
            display: flex;
            flex-direction: column;
            align-items: center;
            backdrop-filter: blur(6px);
            border: 1px solid rgba(255, 255, 255, 0.4);
        }

        .role-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.25);
        }

        .role-card h3 {
            margin-top: 15px;
            font-size: 1.2rem;
        }

        .role-card .role-icon {
            width: 100px;
            height: 100px;
            margin-bottom: 10px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #7c8cff;
        }

        .role-card .role-icon img {
            width: 60px;
            height: 60px;
        }

        /* Bottom boxes */
        .bottom-boxes {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin: 60px 0;
            flex-wrap: wrap;
        }

        .bottom-box {
            background: rgba(255, 255, 255, 0.85);
            padding: 15px 30px;
            border-radius: 12px;
            font-size: 1rem;
            color: #333;
            cursor: pointer;
            transition: all 0.3s ease;
            backdrop-filter: blur(6px);
            border: 1px solid rgba(255, 255, 255, 0.4);
        }

        .bottom-box:hover {
            background: #6c7dff;
            color: white;
            transform: translateY(-3px);
        }

        @media screen and (max-width: 768px) {
            .role-cards {
                flex-direction: column;
                gap: 20px;
            }

            .bottom-boxes {
                flex-direction: column;
                align-items: center;
            }
        }
    </style>
</head>
<body>

<div class="signup-choices-container">
    <h2>Who would you like to Sign Up As?</h2>
    <div class="role-cards">
        <div class="role-card" onclick="location.href='registerUser.jsp'">
            <div class="role-icon">
                <img src="${pageContext.request.contextPath}/assets/images/icons/user2_signup.svg" alt="User"/>
            </div>
            <h3>User</h3>
        </div>
        <div class="role-card" onclick="location.href='registerTechnician.jsp'">
            <div class="role-icon">
                <img src="${pageContext.request.contextPath}/assets/images/icons/tech2_signup.svg" alt="Technician"/>
            </div>
            <h3>Technician</h3>
        </div>
        <div class="role-card" onclick="location.href='registerVolunteer.jsp'">
            <div class="role-icon">
                <img src="${pageContext.request.contextPath}/assets/images/icons/writer_signup.svg" alt="Volunteer"/>
            </div>
            <h3>Volunteer</h3>
        </div>
        <div class="role-card" onclick="location.href='registerDriver.jsp'">
            <div class="role-icon">
                <img src="${pageContext.request.contextPath}/assets/images/icons/driver_signup.svg" alt="Driver"/>
            </div>
            <h3>Driver</h3>
        </div>
        <div class="role-card" onclick="location.href='registerStore.jsp'">
            <div class="role-icon">
                <img src="${pageContext.request.contextPath}/assets/images/icons/entrepreneur.png" alt="Store Owner"/>
            </div>
            <h3>Store Owner</h3>
        </div>
    </div>
</div>

<!-- Footer boxes -->
<div class="bottom-boxes">
    <div class="bottom-box" onclick="location.href='${pageContext.request.contextPath}/login.jsp'">
        Already have an account? <strong>Log In</strong>
    </div>
    <div class="bottom-box" onclick="location.href='${pageContext.request.contextPath}/index.jsp'">
        Go Back Home
    </div>
</div>

</body>
</html>
