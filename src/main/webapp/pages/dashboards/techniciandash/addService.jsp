<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.dailyfixer.model.User" %>

<%
  User user = (User) session.getAttribute("currentUser");
  if (user == null || user.getRole() == null || !"technician".equalsIgnoreCase(user.getRole())) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
  }
%>

<html>
<head>
  <title>Add New Service - DailyFixer</title>
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
    label { display:block; margin-top:15px; font-weight:bold; }
    input[type="text"], input[type="number"], select { width:100%; padding:10px; border-radius:8px; border:1px solid #ccc; margin-top:5px; }
    input[type="file"] { margin-top:5px; }
    .submit-btn {
      margin-top:25px; padding:12px 25px; background:#7c8cff; color:white; border:none; border-radius:10px;
      font-weight:bold; cursor:pointer; transition:0.2s;
    }
    .submit-btn:hover { background:#6b7aff; }
    .back-link { display:inline-block; margin-top:15px; text-decoration:none; color:#7c8cff; }
    .back-link:hover { text-decoration:underline; }
  </style>
</head>
<body>

<%--<jsp:include page="techniciandashmain.jsp"/>--%>

<div class="container">
  <main class="dashboard">
    <div class="form-container">
      <h2>Add New Service</h2>
      <form action="${pageContext.request.contextPath}/AddServiceServlet" method="post" enctype="multipart/form-data">
        <label>Service Name:</label>
        <input type="text" name="serviceName" required>

        <label>Category:</label>
        <input type="text" name="category" required>

        <label>Pricing Type:</label>
        <select name="pricingType" id="pricingType" required onchange="toggleRates()">
          <option value="">Select Type</option>
          <option value="hourly">Hourly</option>
          <option value="fixed">Fixed</option>
        </select>

        <div id="hourlyRateDiv" style="display:none;">
          <label>Hourly Rate (Rs):</label>
          <input type="number" name="hourlyRate" min="0" step="1">
        </div>

        <div id="fixedRateDiv" style="display:none;">
          <label>Fixed Charge (Rs):</label>
          <input type="number" name="fixedRate" min="0" step="1">
        </div>

        <label>Inspection Charge (Rs):</label>
        <input type="number" name="inspectionCharge" min="0" step="1" required>

        <label>Transport Charge (Rs):</label>
        <input type="number" name="transportCharge" min="0" step="1" required>

        <label>Available Dates:</label>
        <input type="text" name="availableDates" placeholder="E.g. Mon-Fri, 9am-5pm" required>

        <label>Service Image:</label>
        <input type="file" name="serviceImage" accept="image/*">

        <button type="submit" class="submit-btn">Add Service</button>
      </form>
      <a href="${pageContext.request.contextPath}/pages/dashboards/techniciandash/serviceListings.jsp" class="back-link">← Back to Service Listings</a>
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
