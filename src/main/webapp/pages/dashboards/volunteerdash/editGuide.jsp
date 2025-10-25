<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.dailyfixer.model.Guide,com.dailyfixer.model.GuideStep,java.util.List" %>

<%
    Guide guide = (Guide) request.getAttribute("guide");
    if (guide == null) {
        response.sendRedirect(request.getContextPath() + "/pages/dashboards/volunteerdash/myguides.jsp");
        return;
    }
%>

<html>
<head>
    <title>Edit Guide - DailyFixer</title>
    <style>
        body {
            background: linear-gradient(to bottom, #ffffff, #c8d9ff);
            font-family: Arial, sans-serif;
            color: #333;
            line-height: 1.6;
            margin: 0;
            padding: 0;
        }

        header {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            z-index: 1000;
        }

        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background-color: #7c8cff;
            padding: 10px 30px;
            border-top-left-radius: 10px;
            border-top-right-radius: 10px;
        }

        .logo {
            font-size: 22px;
            font-weight: bold;
            color: white;
        }

        .nav-links {
            list-style: none;
            display: flex;
            gap: 30px;
            margin: 0;
            padding: 0;
        }

        .nav-links li a {
            text-decoration: none;
            color: white;
            font-weight: bold;
        }

        .subnav {
            background-color: #cfe0ff;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 12px 20px;
            border-radius: 50px;
            margin-top: 5px;
            border: 1px solid #a6c0ff;
            gap: 10px;
        }

        .subnav .store-name {
            font-weight: bold;
            font-size: 20px;
        }

        .subnav ul {
            list-style: none;
            display: flex;
            gap: 2rem;
            margin: 0;
            padding: 0;
        }

        .subnav a {
            text-decoration: none;
            color: #333;
            font-weight: 500;
        }

        .container {
            max-width: 800px;
            margin: 150px auto 50px auto;
            padding: 0 15px;
        }

        .form-container {
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 3px 8px rgba(0,0,0,0.1);
        }

        .form-container h2 {
            margin-bottom: 20px;
            color: #003366;
        }

        label {
            display: block;
            margin-top: 15px;
            font-weight: bold;
        }

        input[type="text"], textarea, input[type="file"] {
            width: 100%;
            padding: 10px;
            border-radius: 8px;
            border: 1px solid #ccc;
            margin-top: 5px;
            box-sizing: border-box;
        }

        textarea {
            resize: vertical;
            min-height: 60px;
        }

        .submit-btn {
            margin-top: 25px;
            padding: 12px 25px;
            background: #7c8cff;
            color: white;
            border: none;
            border-radius: 10px;
            font-weight: bold;
            cursor: pointer;
            transition: 0.2s;
        }

        .submit-btn:hover {
            background: #6b7aff;
        }

        .add-btn, .remove-btn {
            display: inline-block;
            margin-top: 10px;
            padding: 8px 15px;
            color: white;
            font-weight: bold;
            border-radius: 8px;
            cursor: pointer;
            border: none;
        }

        .add-btn {
            background: #7c8cff;
        }

        .add-btn:hover {
            background: #6b7aff;
        }

        .remove-btn {
            background: #ff4c4c;
            margin-left: 10px;
        }

        .remove-btn:hover {
            background: #e04343;
        }

        .current-image {
            max-width: 200px;
            margin: 10px 0;
            border-radius: 8px;
        }

        .step-container {
            border: 1px solid #ddd;
            padding: 15px;
            margin: 15px 0;
            border-radius: 8px;
            background: #f9f9f9;
        }
    </style>
</head>
<body>

<header>
    <div class="navbar">
        <div class="logo">DailyFixer</div>
        <ul class="nav-links">
            <li><a href="${pageContext.request.contextPath}">Home</a></li>
            <li><a href="${pageContext.request.contextPath}/logout">Log Out</a></li>
        </ul>
    </div>
    <div class="subnav">
        <div class="store-name">Volunteer Dashboard</div>
        <ul>
            <li><a href="${pageContext.request.contextPath}/pages/dashboards/volunteerdash/volunteerdashmain.jsp">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/pages/dashboards/volunteerdash/myguides.jsp" class="active">My Guides</a></li>
            <li><a href="${pageContext.request.contextPath}/pages/dashboards/volunteerdash/myProfile.jsp">Profile</a></li>
        </ul>
    </div>
</header>

<div class="container">
    <div class="form-container">
        <h2>Edit Guide</h2>
        <form action="${pageContext.request.contextPath}/EditGuideServlet" method="post" enctype="multipart/form-data">
            <input type="hidden" name="guideId" value="<%= guide.getGuideId() %>">

            <h3>Basic Info</h3>
            <label>Title:</label>
            <input type="text" name="title" value="<%= guide.getTitle() %>" required>

            <label>Main Image:</label>
            <% if (guide.getMainImage() != null) { %>
            <div>
                <img src="${pageContext.request.contextPath}/ImageServlet?id=<%= guide.getGuideId() %>" class="current-image" alt="Current Image">
                <p style="font-size: 12px; color: #666;">Leave empty to keep current image</p>
            </div>
            <% } %>
            <input type="file" name="mainImage" accept="image/*">

            <h3>Requirements</h3>
            <div id="reqDiv">
                <% 
                List<String> requirements = guide.getRequirements();
                if (requirements != null && !requirements.isEmpty()) {
                    for (String req : requirements) {
                %>
                <div class="req-item">
                    <input type="text" name="requirements" placeholder="Requirement" value="<%= req %>">
                    <button type="button" onclick="removeReq(this)" class="remove-btn">Remove</button>
                </div>
                <% 
                    }
                } else {
                %>
                <div class="req-item">
                    <input type="text" name="requirements" placeholder="Requirement">
                </div>
                <% } %>
            </div>
            <button type="button" onclick="addReq()" class="add-btn">+ Add Another Requirement</button>

            <h3>Steps</h3>
            <div id="stepsDiv">
                <% 
                List<GuideStep> steps = guide.getSteps();
                if (steps != null && !steps.isEmpty()) {
                    for (GuideStep step : steps) {
                %>
                <div class="step-container">
                    <label>Step Title:</label>
                    <input type="text" name="stepTitle" placeholder="Step title" value="<%= step.getStepTitle() %>">

                    <label>Step Description:</label>
                    <textarea name="stepDescription" placeholder="Step description"><%= step.getStepDescription() %></textarea>

                    <label>Step Image:</label>
                    <% if (step.getStepImage() != null) { %>
                    <div>
                        <img src="${pageContext.request.contextPath}/StepImageServlet?id=<%= step.getStepId() %>" class="current-image" alt="Step Image">
                        <p style="font-size: 12px; color: #666;">Leave empty to remove image</p>
                    </div>
                    <% } %>
                    <input type="file" name="stepImage" accept="image/*">
                    <button type="button" onclick="removeStep(this)" class="remove-btn">Remove Step</button>
                </div>
                <% 
                    }
                } else {
                %>
                <div class="step-container">
                    <label>Step Title:</label>
                    <input type="text" name="stepTitle" placeholder="Step title">

                    <label>Step Description:</label>
                    <textarea name="stepDescription" placeholder="Step description"></textarea>

                    <label>Step Image:</label>
                    <input type="file" name="stepImage" accept="image/*">
                    <button type="button" onclick="removeStep(this)" class="remove-btn">Remove Step</button>
                </div>
                <% } %>
            </div>
            <button type="button" onclick="addStep()" class="add-btn">+ Add Another Step</button><br>

            <button type="submit" class="submit-btn">Update Guide</button><br>
            <a href="${pageContext.request.contextPath}/pages/dashboards/volunteerdash/myguides.jsp" class="add-btn" style="background:#555; margin-right:10px; text-decoration: none; display: inline-block;">← Back to My Guides</a>
        </form>
    </div>
</div>

<script>
    function addReq() {
        const div = document.createElement("div");
        div.className = "req-item";
        div.innerHTML = '<input type="text" name="requirements" placeholder="Requirement">' +
                       '<button type="button" onclick="removeReq(this)" class="remove-btn">Remove</button>';
        document.getElementById("reqDiv").appendChild(div);
    }

    function removeReq(btn) {
        btn.parentElement.remove();
    }

    function addStep() {
        const div = document.createElement("div");
        div.className = "step-container";
        div.innerHTML = `
            <label>Step Title:</label>
            <input type="text" name="stepTitle" placeholder="Step title">
            <label>Step Description:</label>
            <textarea name="stepDescription" placeholder="Step description"></textarea>
            <label>Step Image:</label>
            <input type="file" name="stepImage" accept="image/*">
            <button type="button" onclick="removeStep(this)" class="remove-btn">Remove Step</button>
        `;
        document.getElementById("stepsDiv").appendChild(div);
    }

    function removeStep(btn) {
        btn.parentElement.remove();
    }
</script>

</body>
</html>
