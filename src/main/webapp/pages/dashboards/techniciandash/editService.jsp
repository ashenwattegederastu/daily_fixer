<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.dailyfixer.model.Service" %>

<%
    Service s = (Service) request.getAttribute("service");
    if (s == null) {
        response.sendRedirect(request.getContextPath() + "/pages/dashboards/techniciandash/serviceListings.jsp");
        return;
    }
%>

<html>
<head>
    <title>Edit Service - DailyFixer</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/deliverdashmain.css">
    <style>
        .form-container {
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 3px 8px rgba(0,0,0,0.1);
            max-width: 700px;
            margin: 0 auto 50px auto;
        }
        .form-container h2 { margin-bottom: 20px; color: #003366; }
        label { display: block; margin-top: 15px; font-weight: bold; }
        input[type="text"], input[type="number"], select { width: 100%; padding: 10px; border-radius: 8px; border: 1px solid #ccc; margin-top: 5px; }
        input[type="file"] { margin-top: 5px; }
        .submit-btn { margin-top: 25px; padding: 12px 25px; background: #7c8cff; color: white; border: none; border-radius: 10px; font-weight: bold; cursor: pointer; transition: 0.2s; }
        .submit-btn:hover { background: #6b7aff; }
        .back-link { display: inline-block; margin-top: 15px; text-decoration: none; color: #7c8cff; }
        .back-link:hover { text-decoration: underline; }
    </style>
</head>
<body>
<header>
    <!-- Main Navbar -->
    <nav class="navbar">
        <div class="logo">Daily Fixer</div>
        <ul class="nav-links">
            <li><a href="${pageContext.request.contextPath}">Home</a></li>
            <li><a href="${pageContext.request.contextPath}/logout">Log Out</a></li>
        </ul>
    </nav>
    <!-- Subnav -->
    <nav class="subnav">
        <div class="store-name">Technician Dashboard</div>
        <ul>
            <li><a href="${pageContext.request.contextPath}/pages/dashboards/techdash/techniciandashmain.jsp">Dashboard</a></li>
            <li><a href="#">Bookings</a></li>
            <li><a href="${pageContext.request.contextPath}/pages/dashboards/techdash/serviceListings.jsp" class="active">Service Listing</a></li>
            <li><a href="#">Verification</a></li>
            <li><a href="${pageContext.request.contextPath}/pages/dashboards/techdash/myProfile.jsp">Profile</a></li>
        </ul>
    </nav>
</header>

<div class="container">
    <main class="dashboard">
        <div class="form-container">
            <h2>Edit Service</h2>
            <form action="${pageContext.request.contextPath}/EditServiceServlet" method="post" enctype="multipart/form-data">
                <input type="hidden" name="serviceId" value="<%= s.getServiceId() %>">

                <label for="serviceName">Service Name:</label>
                <input type="text" name="serviceName" id="serviceName" value="<%= s.getServiceName() %>" required>

                <label for="category">Category:</label>
                <input type="text" name="category" id="category" value="<%= s.getCategory() %>" required>

                <label for="pricingType">Pricing Type:</label>
                <select name="pricingType" id="pricingType" required onchange="toggleRates()">
                    <option value="">Select Type</option>
                    <option value="hourly" <%= "hourly".equalsIgnoreCase(s.getPricingType()) ? "selected" : "" %>>Hourly</option>
                    <option value="fixed" <%= "fixed".equalsIgnoreCase(s.getPricingType()) ? "selected" : "" %>>Fixed</option>
                </select>

                <div id="hourlyRateDiv" style="display:<%= "hourly".equalsIgnoreCase(s.getPricingType()) ? "block" : "none" %>;">
                    <label for="hourlyRate">Hourly Rate (Rs):</label>
                    <input type="number" name="hourlyRate" id="hourlyRate" value="<%= s.getHourlyRate() %>">
                </div>

                <div id="fixedRateDiv" style="display:<%= "fixed".equalsIgnoreCase(s.getPricingType()) ? "block" : "none" %>;">
                    <label for="fixedRate">Fixed Charge (Rs):</label>
                    <input type="number" name="fixedRate" id="fixedRate" value="<%= s.getFixedRate() %>">
                </div>

                <label for="inspectionCharge">Inspection Charge (Rs):</label>
                <input type="number" name="inspectionCharge" id="inspectionCharge" value="<%= s.getInspectionCharge() %>" required>

                <label for="transportCharge">Transport Charge (Rs):</label>
                <input type="number" name="transportCharge" id="transportCharge" value="<%= s.getTransportCharge() %>" required>

                <label for="availableDates">Available Dates:</label>
                <input type="text" name="availableDates" id="availableDates" value="<%= s.getAvailableDates() %>" required>

                <label for="serviceImage">Service Image:</label>
                <input type="file" name="serviceImage" id="serviceImage" accept="image/*">

                <button type="submit" class="submit-btn">Update Service</button>
            </form>
            <a href="${pageContext.request.contextPath}/pages/dashboards/techdash/serviceListings.jsp" class="back-link">← Back to Service Listings</a>
        </div>
    </main>
</div>

<script>
    function toggleRates() {
        const type = document.getElementById('pricingType').value;
        document.getElementById('hourlyRateDiv').style.display = type === 'hourly' ? 'block' : 'none';
        document.getElementById('fixedRateDiv').style.display = type === 'fixed' ? 'block' : 'none';
    }
</script>
</body>
</html>
