<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="guide" value="${requestScope.guide}" />

<html>
<head>
    <title><c:out value="${guide.title}"/> - DailyFixer</title>
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
    <c:if test="${guide.mainImage != null}">
    <img src="${pageContext.request.contextPath}/ImageServlet?id=${guide.guideId}" class="main-image" alt="<c:out value='${guide.title}'/>">
    </c:if>

    <!-- Title -->
    <div class="guide-title"><c:out value="${guide.title}"/></div>

    <!-- Requirements -->
    <div class="section-title">Requirements</div>
    <c:choose>
        <c:when test="${guide.requirements != null && !guide.requirements.isEmpty()}">
    <ul class="requirements-list">
        <c:forEach var="r" items="${guide.requirements}">
        <li><c:out value="${r}"/></li>
        </c:forEach>
    </ul>
        </c:when>
        <c:otherwise>
    <p>No requirements specified.</p>
        </c:otherwise>
    </c:choose>

    <!-- Steps -->
    <div class="section-title">Steps</div>
    <c:choose>
        <c:when test="${guide.steps != null && !guide.steps.isEmpty()}">
            <c:forEach var="s" items="${guide.steps}" varStatus="status">
    <div class="step">
        <div class="step-header">Step ${status.index + 1}: <c:out value="${s.stepTitle}"/></div>
        <div class="step-content">
            <c:if test="${s.stepImage != null}">
            <img src="${pageContext.request.contextPath}/StepImageServlet?id=${s.stepId}" class="step-image" alt="Step ${status.index + 1}">
            </c:if>
            <div class="step-description"><c:out value="${s.stepDescription}"/></div>
        </div>
    </div>
            </c:forEach>
        </c:when>
        <c:otherwise>
    <p>No steps added yet.</p>
        </c:otherwise>
    </c:choose>

    <a href="${pageContext.request.contextPath}/ViewGuidesServlet" class="back-btn">← Back to All Guides</a>
</div>

</body>
</html>
