<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.dailyfixer.model.Guide,com.dailyfixer.model.GuideStep" %>
<%@ page import="java.util.List" %>

<%
    Guide guide = (Guide) request.getAttribute("guide");
%>

<html>
<head>
    <title><%= guide.getTitle() %></title>
    <style>
        .guide-container { max-width:800px; margin:0 auto; padding:20px; }
        .guide-container img { max-width:100%; height:auto; margin-bottom:10px; }
        .step { border-top:1px solid #ccc; padding-top:10px; margin-top:10px; }
        .step img { width:200px; height:150px; object-fit:cover; display:block; margin-top:5px; }
    </style>
</head>
<body>
<div class="guide-container">
    <h2><%= guide.getTitle() %></h2>
    <img src="${pageContext.request.contextPath}/ImageServlet?id=<%= guide.getGuideId() %>" alt="Main Image">

    <h3>Requirements</h3>
    <ul>
        <% for (String r : guide.getRequirements()) { %>
        <li><%= r %></li>
        <% } %>
    </ul>

    <h3>Steps</h3>
    <% List<GuideStep> steps = guide.getSteps();
        if (steps != null) {
            for (GuideStep s : steps) { %>
    <div class="step">
        <strong><%= s.getTitle() %></strong>
        <p><%= s.getDescription() %></p>
        <% if (s.getImage() != null) { %>
        <img src="${pageContext.request.contextPath}/StepImageServlet?id=<%= s.getStepId() %>">
        <% } %>
    </div>
    <%     }
    } %>
</div>
</body>
</html>
