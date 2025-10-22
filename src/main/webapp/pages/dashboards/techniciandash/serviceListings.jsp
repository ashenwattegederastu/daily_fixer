<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.dailyfixer.model.Service" %>
<%@ page import="com.dailyfixer.dao.ServiceDAO" %>
<%@ page import="com.dailyfixer.model.User" %>

<%
    User user = (User) session.getAttribute("currentUser");
    if (user == null || user.getRole() == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String role = user.getRole().trim().toLowerCase();
    if (!("technician".equals(role))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    ServiceDAO dao = new ServiceDAO();
    List<Service> services = dao.getServicesByTechnician(user.getUserId());
%>

<html>
<head>
    <title>Service Listings - DailyFixer</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/deliverdashmain.css">
    <style>
        /* Extra styling for the table to match the dashboard aesthetic */
        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            box-shadow: 0 3px 8px rgba(0,0,0,0.1);
            border-radius: 12px;
            overflow: hidden;
        }
        th, td {
            padding: 12px 14px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        th {
            background: #7c8cff;
            color: white;
            font-weight: bold;
        }
        tr:hover {
            background-color: #f7faff;
        }
        .add-btn {
            display: inline-block;
            margin-bottom: 20px;
            background: #7c8cff;
            color: white;
            padding: 10px 20px;
            border-radius: 10px;
            text-decoration: none;
            font-weight: bold;
            transition: 0.2s ease;
        }
        .add-btn:hover {
            background: #6b7aff;
        }
        img.service-thumb {
            width: 100px;
            height: 80px;
            border-radius: 8px;
            object-fit: cover;
        }
        .actions a {
            color: #7c8cff;
            text-decoration: none;
            font-weight: 500;
            margin-right: 10px;
        }
        .actions a:hover {
            text-decoration: underline;
        }
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
        <h2>My Service Listings</h2>
        <p class="subtitle">Manage your available services, rates, and inspection charges</p>

        <a href="${pageContext.request.contextPath}/pages/dashboards/techniciandash/addService.jsp" class="add-btn">+ Add New Service</a>

        <table>
            <tr>
                <th>Image</th>
                <th>Service Name</th>
                <th>Category</th>
                <th>Pricing Type</th>
                <th>Charges</th>
                <th>Available Dates</th>
                <th>Actions</th>
            </tr>

            <%
                if (services != null && !services.isEmpty()) {
                    for (Service s : services) {
            %>
            <tr>
                <td><img src="${pageContext.request.contextPath}/ServiceImageServlet?service_id=<%=s.getServiceId()%>" class="service-thumb"></td>
                <td><%=s.getServiceName()%></td>
                <td><%=s.getCategory()%></td>
                <td><%=s.getPricingType().equals("fixed") ? "Fixed (Rs. " + s.getFixedRate() + ")" : "Hourly (Rs. " + s.getHourlyRate() + "/hr)" %></td>
                <td>
                    Inspection: Rs.<%=s.getInspectionCharge()%><br>
                    Transport: Rs.<%=s.getTransportCharge()%>
                </td>
                <td><%=s.getAvailableDates()%></td>
                <td class="actions">
<%--                    <a href="${pageContext.request.contextPath}/pages/dashboards/techniciandash/editService.jsp?id=<%=s.getServiceId()%>">Edit</a>--%>
    <a href="${pageContext.request.contextPath}/EditServiceServlet?id=<%= s.getServiceId() %>">Edit</a>

<%--    <a href="${pageContext.request.contextPath}/DeleteServiceServlet?id=<%=s.getServiceId()%>" onclick="return confirm('Are you sure you want to delete this service?')">Delete</a>--%>
                <a href="${pageContext.request.contextPath}/DeleteServiceServlet?id=<%=s.getServiceId()%>"
                     onclick="return confirm('Are you sure you want to delete this service?');">
                    Delete
                    </a>

            </tr>
            <%
                }
            } else {
            %>
            <tr>
                <td colspan="7" style="text-align:center; color:#666;">No service listings found. Click “Add New Service” to create one.</td>
            </tr>
            <% } %>
        </table>
    </main>
</div>

</body>
</html>
