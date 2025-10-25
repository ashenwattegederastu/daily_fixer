<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.dailyfixer.model.Guide,com.dailyfixer.model.GuideStep" %>
<%@ page import="java.util.List" %>

<%
    Guide guide = (Guide) request.getAttribute("guide");
%>

<html>
<head>
    <title><%= guide.getTitle() %> - DailyFixer</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(to bottom, #ffffff, #c8d9ff);
            margin: 0;
            padding: 0;
            color: #333;
        }

        .navbar {
            background-color: #7c8cff;
            padding: 15px 30px;
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .navbar .logo {
            font-size: 22px;
            font-weight: bold;
        }

        .navbar a {
            color: white;
            text-decoration: none;
            margin-left: 20px;
            font-weight: bold;
        }

        .guide-container {
            max-width: 900px;
            margin: 30px auto;
            padding: 30px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 3px 8px rgba(0,0,0,0.1);
        }

        .main-image {
            width: 100%;
            max-height: 400px;
            object-fit: cover;
            border-radius: 10px;
            margin-bottom: 20px;
        }

        .guide-title {
            font-size: 32px;
            font-weight: bold;
            color: #003366;
            margin-bottom: 20px;
        }

        .section-title {
            font-size: 24px;
            font-weight: bold;
            color: #003366;
            margin-top: 30px;
            margin-bottom: 15px;
            border-bottom: 2px solid #7c8cff;
            padding-bottom: 5px;
        }

        .requirements-list {
            list-style: disc;
            padding-left: 30px;
            margin-bottom: 20px;
        }

        .requirements-list li {
            margin-bottom: 8px;
            line-height: 1.6;
        }

        .step {
            border-top: 2px solid #ddd;
            padding: 20px 0;
            margin-top: 20px;
        }

        .step:first-of-type {
            border-top: none;
            margin-top: 0;
        }

        .step-header {
            font-size: 20px;
            font-weight: bold;
            color: #003366;
            margin-bottom: 15px;
        }

        .step-content {
            display: flex;
            gap: 20px;
            align-items: flex-start;
        }

        .step-image {
            flex-shrink: 0;
            width: 300px;
            height: 225px;
            object-fit: cover;
            border-radius: 8px;
        }

        .step-description {
            flex: 1;
            line-height: 1.8;
            font-size: 16px;
        }

        .back-btn {
            display: inline-block;
            margin-top: 30px;
            padding: 12px 25px;
            background: #7c8cff;
            color: white;
            text-decoration: none;
            border-radius: 10px;
            font-weight: bold;
            transition: 0.2s;
        }

        .back-btn:hover {
            background: #6b7aff;
        }

        @media (max-width: 768px) {
            .step-content {
                flex-direction: column;
            }

            .step-image {
                width: 100%;
            }
        }
    </style>
</head>
<body>

<div class="navbar">
    <div class="logo">DailyFixer</div>
    <div>
        <a href="${pageContext.request.contextPath}">Home</a>
        <a href="${pageContext.request.contextPath}/ViewGuidesServlet">All Guides</a>
    </div>
</div>

<div class="guide-container">
    <!-- Main Image -->
    <% if (guide.getMainImage() != null) { %>
    <img src="${pageContext.request.contextPath}/ImageServlet?id=<%= guide.getGuideId() %>" class="main-image" alt="<%= guide.getTitle() %>">
    <% } %>

    <!-- Title -->
    <div class="guide-title"><%= guide.getTitle() %></div>

    <!-- Requirements -->
    <div class="section-title">Requirements</div>
    <% if (guide.getRequirements() != null && !guide.getRequirements().isEmpty()) { %>
    <ul class="requirements-list">
        <% for (String r : guide.getRequirements()) { %>
        <li><%= r %></li>
        <% } %>
    </ul>
    <% } else { %>
    <p>No requirements specified.</p>
    <% } %>

    <!-- Steps -->
    <div class="section-title">Steps</div>
    <% 
    List<GuideStep> steps = guide.getSteps();
    if (steps != null && !steps.isEmpty()) {
        int stepNum = 1;
        for (GuideStep s : steps) { 
    %>
    <div class="step">
        <div class="step-header">Step <%= stepNum %>: <%= s.getStepTitle() %></div>
        <div class="step-content">
            <% if (s.getStepImage() != null) { %>
            <img src="${pageContext.request.contextPath}/StepImageServlet?id=<%= s.getStepId() %>" class="step-image" alt="Step <%= stepNum %>">
            <% } %>
            <div class="step-description"><%= s.getStepDescription() %></div>
        </div>
    </div>
    <%     
            stepNum++;
        }
    } else { %>
    <p>No steps added yet.</p>
    <% } %>

    <a href="${pageContext.request.contextPath}/ViewGuidesServlet" class="back-btn">← Back to All Guides</a>
</div>

</body>
</html>
