<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="pages/shared/header.jsp" %>
<%
    request.setAttribute("activePage", "home"); // highlight Home
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Daily Fixer</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto+Condensed:ital,wght@0,100..900;1,100..900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/navbar.css">
    <link rel="stylesheet" href="assets/css/main.css">
    <style>
        .welcome-text {
            font-family: 'Roboto Condensed', sans-serif;
            text-transform: none;
            letter-spacing: 0.5px;
            font-size: 13rem;
            color: white;
            text-align: center;
            margin-top: 40px;
        }
        /* Hide scrollbar but keep scroll functionality */
        body {
            overflow: auto;
        }

        /* For Chrome, Edge, and Safari */
        body::-webkit-scrollbar {
            display: none;
        }

        /* For Firefox */
        body {
            scrollbar-width: none;
        }

        /* For Internet Explorer and older Edge */
        body {
            -ms-overflow-style: none;
        }

    </style>
</head>
<body>
<section class="hero">
    <div class="hero-content">
        <!-- Welcome / Join Text -->
        <c:choose>
            <c:when test="${not empty sessionScope.currentUser}">
                <h1 class="welcome-text">
                    Welcome, ${sessionScope.currentUser.firstName} ${sessionScope.currentUser.lastName}!
                </h1>
            </c:when>
            <c:otherwise>
                <h1 class="welcome-text">
                    Join a community that helps you fix, learn, and restore what matters.
                </h1>
            </c:otherwise>
        </c:choose>

        <!-- Search Box (only if logged in) -->
        <c:if test="${not empty sessionScope.currentUser}">
            <div class="search-box">
                <label for="search" class="sr-only">Search for an issue</label>
                <input type="text" id="search" placeholder="Search for an issue">
                <button><img src="assets/images/pictures/search.png" alt="Search"></button>
            </div>
        </c:if>
    </div>
</section>

<div class="container">
    <section class="guides">
        <h2>Featured Guides</h2>
        <div class="guide-cards">
            <a href="faucet.html" class="card">
                <img src="assets/images/pictures/faucet.jpg" alt="">
                <p><strong>How to Fix a Leaky Faucet</strong><br>Step-by-step guide to fixing a leaky faucet.</p>
            </a>
            <a href="engine.html" class="card">
                <img src="assets/images/pictures/engine.jpg" alt="">
                <p><strong>Engine Maintenance Basics</strong><br>Learn simple engine maintenance tasks.</p>
            </a>
            <a href="electrical.html" class="card">
                <img src="assets/images/pictures/electrical.jpg" alt="">
                <p><strong>Safe home electrical repairs</strong><br>Keep your family safe performing electrical repairs.</p>
            </a>
            <a href="bicycle.html" class="card">
                <img src="assets/images/pictures/bicycle.jpg" alt="">
                <p><strong>Bike Tire Replacement Guide</strong><br>Easy step-by-step instructions for replacing bike tires.</p>
            </a>
        </div>
    </section>
</div>

<section class="about" id="about">
    <h2>About Us</h2>
    <div class="about-content">
        <div class="about-text">
            <p>At Daily Fixer, we believe every problem has a solution...</p>
        </div>
        <div class="about-images">
            <img src="assets/images/pictures/car.jpg" alt="">
            <img src="assets/images/pictures/painter.jpg" alt="">
        </div>
    </div>
</section>

<section class="services" id="services">
    <h2>Our Services</h2>
    <!-- buttons etc. -->
</section>

<%@ include file="pages/shared/footer.jsp" %>
</body>
</html>
