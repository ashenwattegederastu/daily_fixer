<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
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

    VehicleDAO dao = new VehicleDAO();
    List<Vehicle> vehicles = dao.getVehiclesByDriver(user.getUserId());
%>

<html>
<head>
    <title>Vehicle Management</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/vehicleManagement.css">
    <style>
        .vehicle-cards { display: flex; flex-wrap: wrap; gap: 20px; }
        .vehicle-card { border: 1px solid #ccc; border-radius: 8px; padding: 15px; width: 220px; text-align: center; position: relative; }
        .vehicle-card img { width: 200px; height: 120px; object-fit: cover; border-radius: 5px; }
        .add-vehicle-btn { margin: 20px 0; padding: 10px 20px; background: #28a745; color: white; border: none; border-radius: 5px; cursor: pointer; }
        .vehicle-form { display: none; margin-top: 20px; border: 1px solid #ccc; padding: 15px; border-radius: 8px; max-width: 400px; }
        .vehicle-form input, .vehicle-form button { display: block; margin: 10px 0; width: 100%; padding: 8px; }
        .vehicle-card .actions { margin-top: 10px; }
        .vehicle-card .actions a { display: inline-block; margin: 5px; padding: 5px 10px; border-radius: 4px; text-decoration: none; color: white; }
        .edit-btn { background-color: #007bff; }
        .delete-btn { background-color: #dc3545; }
    </style>
    <script>
        function toggleForm() {
            const form = document.getElementById('addVehicleForm');
            form.style.display = form.style.display === 'block' ? 'none' : 'block';
        }

        function openEditForm(vehicleId, type, brand, model, plate, fare1, fareNext) {
            const form = document.getElementById('addVehicleForm');
            form.style.display = 'block';
            form.action = '${pageContext.request.contextPath}/EditVehicleServlet';
            document.getElementById('vehicleId').value = vehicleId;
            document.getElementById('vehicleType').value = type;
            document.getElementById('brand').value = brand;
            document.getElementById('model').value = model;
            document.getElementById('plateNumber').value = plate;
            document.getElementById('fareFirstKm').value = fare1;
            document.getElementById('fareNextKm').value = fareNext;
        }
    </script>
</head>
<body>
<header>
    <nav class="navbar">
        <div class="logo">Daily Fixer</div>
        <ul class="nav-links">
            <li><a href="${pageContext.request.contextPath}">Home</a></li>
            <li><a href="${pageContext.request.contextPath}/LogoutServlet">Log Out</a></li>
        </ul>
    </nav>
    <nav class="subnav">
        <div class="store-name">Driver</div>
        <ul>
            <li><a href="${pageContext.request.contextPath}/pages/dashboards/driverdash/driverdashmain.jsp">Dashboard</a></li>
            <li><a href="#" class="active">Vehicle Management</a></li>
            <li><a href="#">Delivery Requests</a></li>
            <li><a href="#">Profile</a></li>
        </ul>
    </nav>
</header>

<div class="container">
    <h2>Vehicle Management</h2>

    <!-- Add/Edit Vehicle Form -->
    <button class="add-vehicle-btn" onclick="toggleForm()">Add Vehicle</button>
    <form id="addVehicleForm" action="${pageContext.request.contextPath}/AddVehicleServlet" method="post" enctype="multipart/form-data" class="vehicle-form">
        <h3>Add / Edit Vehicle</h3>
        <input type="hidden" id="vehicleId" name="id">
        <input type="text" id="vehicleType" name="vehicleType" placeholder="Vehicle Type" required>
        <input type="text" id="brand" name="brand" placeholder="Brand" required>
        <input type="text" id="model" name="model" placeholder="Model" required>
        <input type="text" id="plateNumber" name="plateNumber" placeholder="Plate Number" required>
        <input type="file" name="picture" accept="image/*">
        <input type="number" step="0.01" id="fareFirstKm" name="fareFirstKm" placeholder="Fare for 1st KM" required>
        <input type="number" step="0.01" id="fareNextKm" name="fareNextKm" placeholder="Fare for next KMs" required>
        <button type="submit">Submit</button>
    </form>

    <!-- Vehicles Display -->
    <div class="vehicle-cards">
        <% for (Vehicle vehicle : vehicles) { %>
        <div class="vehicle-card">
            <img src="${pageContext.request.contextPath}/GetVehicleImageServlet?id=<%= vehicle.getId() %>" alt="Vehicle Image">
            <p><strong>Type:</strong> <%= vehicle.getVehicleType() %></p>
            <p><strong>Brand:</strong> <%= vehicle.getBrand() %></p>
            <p><strong>Model:</strong> <%= vehicle.getModel() %></p>
            <p><strong>Plate:</strong> <%= vehicle.getPlateNumber() %></p>
            <p><strong>Fare 1st KM:</strong> <%= vehicle.getFareFirstKm() %></p>
            <p><strong>Fare Next KMs:</strong> <%= vehicle.getFareNextKm() %></p>
            <div class="actions">
                <a href="javascript:void(0);" class="edit-btn"
                   onclick="openEditForm('<%= vehicle.getId() %>', '<%= vehicle.getVehicleType() %>', '<%= vehicle.getBrand() %>', '<%= vehicle.getModel() %>', '<%= vehicle.getPlateNumber() %>', '<%= vehicle.getFareFirstKm() %>', '<%= vehicle.getFareNextKm() %>')">Edit</a>
                <a href="${pageContext.request.contextPath}/DeleteVehicleServlet?id=<%= vehicle.getId() %>" class="delete-btn" onclick="return confirm('Are you sure you want to delete this vehicle?');">Delete</a>
            </div>
        </div>
        <% } %>
        <% if (vehicles.isEmpty()) { %>
        <p>No vehicles added yet. Click "Add Vehicle" to register your first vehicle.</p>
        <% } %>
    </div>
</div>
</body>
</html>
