<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.dailyfixer.model.Vehicle" %>
<%@ page import="com.dailyfixer.dao.VehicleDAO" %>
<%@ page import="com.dailyfixer.model.User" %>
<%
  // Get logged-in user
  User user = (User) session.getAttribute("currentUser");
  if (user == null || !"driver".equals(user.getRole())) {
    response.sendRedirect(request.getContextPath() + "/pages/shared/login.jsp");
    return;
  }

  // Get vehicle ID from query parameter
  String idParam = request.getParameter("id");
  if (idParam == null || idParam.isEmpty()) {
    response.sendRedirect(request.getContextPath() + "/pages/dashboards/driverdash/vehicleManagement.jsp");
    return;
  }

  int vehicleId = Integer.parseInt(idParam);
  VehicleDAO dao = new VehicleDAO();
  Vehicle vehicle = dao.getVehicleById(vehicleId);

  if (vehicle == null || vehicle.getDriverId() != user.getUserId()) {
    response.sendRedirect(request.getContextPath() + "/pages/dashboards/driverdash/vehicleManagement.jsp");
    return;
  }
%>

<html>
<head>
  <title>Edit Vehicle</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/vehicleManagement.css">
  <style>
    .vehicle-form { max-width: 400px; margin: 20px auto; border: 1px solid #ccc; padding: 15px; border-radius: 8px; }
    .vehicle-form input, .vehicle-form button { display: block; margin: 10px 0; width: 100%; padding: 8px; }
    .current-image { width: 200px; height: 120px; object-fit: cover; border-radius: 5px; margin-bottom: 10px; }
  </style>
</head>
<body>
<div class="container">
  <h2>Edit Vehicle</h2>
  <form action="${pageContext.request.contextPath}/EditVehicleServlet" method="post" enctype="multipart/form-data" class="vehicle-form">
    <input type="hidden" name="id" value="<%= vehicle.getId() %>">

    <label>Current Image:</label>
    <img src="${pageContext.request.contextPath}/GetVehicleImageServlet?id=<%= vehicle.getId() %>" class="current-image" alt="Vehicle Image">

    <input type="text" name="vehicleType" value="<%= vehicle.getVehicleType() %>" placeholder="Vehicle Type" required>
    <input type="text" name="brand" value="<%= vehicle.getBrand() %>" placeholder="Brand" required>
    <input type="text" name="model" value="<%= vehicle.getModel() %>" placeholder="Model" required>
    <input type="text" name="plateNumber" value="<%= vehicle.getPlateNumber() %>" placeholder="Plate Number" required>
    <input type="file" name="picture" accept="image/*">
    <input type="number" step="0.01" name="fareFirstKm" value="<%= vehicle.getFareFirstKm() %>" placeholder="Fare for 1st KM" required>
    <input type="number" step="0.01" name="fareNextKm" value="<%= vehicle.getFareNextKm() %>" placeholder="Fare for next KMs" required>

    <button type="submit">Update Vehicle</button>
  </form>
</div>
</body>
</html>
