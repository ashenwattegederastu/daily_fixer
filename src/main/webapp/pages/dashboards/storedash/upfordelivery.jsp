<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.dailyfixer.model.User" %>

<%
    User user = (User) session.getAttribute("currentUser");
    if (user == null || user.getRole() == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String role = user.getRole().trim().toLowerCase();
    if (!("admin".equals(role) || "store".equals(role))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Up for Delivery | Daily Fixer</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

<style>
:root {
    --panel-color: #dcdaff;
    --accent: #8b95ff;
    --text-dark: #000000;
    --text-secondary: #333333;
    --shadow-sm: 0 4px 12px rgba(0,0,0,0.12);
    --shadow-md: 0 8px 24px rgba(0,0,0,0.18);
    --shadow-lg: 0 12px 36px rgba(0,0,0,0.22);
}

/* Reset */
* { margin:0; padding:0; box-sizing:border-box; }
body {
    font-family: 'Inter', sans-serif;
    background-color: #ffffff;
    color: var(--text-dark);
    display: flex;
    min-height: 100vh;
}

/* Top Navbar */
.topbar {
    position: fixed;
    top:0; left:0; right:0;
    height:76px;
    background-color: var(--panel-color);
    border-bottom: 1px solid rgba(0,0,0,0.1);
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0 30px;
    z-index: 200;
    box-shadow: var(--shadow-md);
}
.topbar .logo { font-size: 1.5em; font-weight: 700; color: var(--accent); }
.topbar .panel-name { font-weight: 600; flex:1; text-align:center; color: var(--text-dark); }
.topbar .logout-btn {
    padding: 0.6rem 1.2rem;
    background: linear-gradient(135deg, var(--accent), #7ba3d4);
    border: none;
    color: #fff;
    border-radius: 8px;
    cursor: pointer;
    font-weight: 600;
    font-size: 0.9rem;
    box-shadow: var(--shadow-sm);
    text-decoration: none;
}
.topbar .logout-btn:hover {
    transform: translateY(-2px);
    box-shadow: var(--shadow-md);
    opacity: 0.9;
}

/* Sidebar */
.sidebar {
    width: 240px;
    background-color: var(--panel-color);
    height: 100vh;
    position: fixed;
    top:0;
    left:0;
    padding-top: 96px;
    box-shadow: var(--shadow-md);
    overflow-y: auto;
    z-index: 100;
}
.sidebar h3 { padding: 0 20px 12px; font-size: 0.85em; color: var(--text-dark); text-transform: uppercase; }
.sidebar ul { list-style:none; }
.sidebar a {
    display:block;
    padding:12px 20px;
    text-decoration:none;
    color: var(--text-dark);
    font-weight:500;
    border-left:3px solid transparent;
    border-radius:0 8px 8px 0;
    margin-bottom:4px;
    transition: all 0.2s;
}
.sidebar a:hover, .sidebar a.active {
    background-color: #f0f0ff;
    border-left-color: var(--accent);
}

/* Main Content */
.container {
    flex:1;
    margin-left:240px;
    margin-top:83px;
    padding:30px;
}
.container h2 {
    font-size:1.6em;
    margin-bottom:20px;
    color: #000000;
}

/* Table Styles */
table {
    width:100%;
    border-collapse: collapse;
    box-shadow: var(--shadow-sm);
    background: white;
    border-radius: 12px;
    overflow: hidden;
    border: 1px solid rgba(0,0,0,0.1);
}
thead { background-color: var(--panel-color); }
th, td {
    padding:12px 10px;
    text-align:left;
    border-bottom:1px solid #ddd;
}
tbody tr:hover { background-color:#f9f9f9; }

td .status {
    display:inline-block;
    width:14px;
    height:14px;
    border-radius:50%;
    margin-right: 8px;
}
.status.out-delivery { background-color: #3498db; }

/* Buttons */
.btn { 
    padding:6px 12px; 
    border:none; 
    border-radius:8px; 
    cursor:pointer; 
    font-weight:500; 
    margin-right:5px;
    font-size: 0.85em;
}
.view-btn { background:#20255b; color:#fff; }
.track-btn { background: #27ae60; color:#fff; }
.update-btn { background: var(--accent); color:#fff; }

.btn:hover {
    opacity: 0.9;
    transform: translateY(-1px);
}

/* Vehicle Type Badge */
.vehicle-badge {
    display: inline-block;
    padding: 4px 8px;
    border-radius: 12px;
    font-size: 0.75em;
    font-weight: 600;
    text-transform: uppercase;
}
.vehicle-bike { background: #e8f5e8; color: #27ae60; }
.vehicle-threewheel { background: #e3f2fd; color: #1976d2; }
.vehicle-van { background: #fff3e0; color: #f57c00; }
.vehicle-lorry { background: #fce4ec; color: #c2185b; }
</style>
</head>
<body>

<header class="topbar">
    <div class="logo">Daily Fixer</div>
    <div class="panel-name">Store Panel</div>
    <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Log Out</a>
</header>

<aside class="sidebar">
    <h3>Navigation</h3>
    <ul>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/storedashmain.jsp">Dashboard</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/orders.jsp">Orders</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/upfordelivery.jsp" class="active">Up for Delivery</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/completedorders.jsp">Completed Orders</a></li>
        <li><a href="${pageContext.request.contextPath}/ListProductsServlet">Catalogue</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/myProfile.jsp">Profile</a></li>
    </ul>
</aside>

<main class="container">
    <h2>Orders Up for Delivery</h2>
    
    <table>
        <thead>
            <tr>
                <th>Order ID</th>
                <th>Customer</th>
                <th>Date</th>
                <th>Vehicle Type</th>
                <th>Driver</th>
                <th>Status</th>
                <th>Total</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>001</td>
                <td>Kamal Silva</td>
                <td>2025-07-20</td>
                <td><span class="vehicle-badge vehicle-bike">Bike</span></td>
                <td>Rajesh Kumar</td>
                <td><span class="status out-delivery"></span>Out for Delivery</td>
                <td>LKR 1,100</td>
                <td>
                    <button class="btn view-btn">View Details</button>
                    <button class="btn track-btn">Track Order</button>
                    <button class="btn update-btn">Update Status</button>
                </td>
            </tr>
            <tr>
                <td>003</td>
                <td>Nimal Perera</td>
                <td>2025-07-19</td>
                <td><span class="vehicle-badge vehicle-van">Van</span></td>
                <td>Suresh Fernando</td>
                <td><span class="status out-delivery"></span>Out for Delivery</td>
                <td>LKR 2,500</td>
                <td>
                    <button class="btn view-btn">View Details</button>
                    <button class="btn track-btn">Track Order</button>
                    <button class="btn update-btn">Update Status</button>
                </td>
            </tr>
            <tr>
                <td>004</td>
                <td>Priya Jayawardena</td>
                <td>2025-07-21</td>
                <td><span class="vehicle-badge vehicle-threewheel">Three Wheel</span></td>
                <td>Anil Perera</td>
                <td><span class="status out-delivery"></span>Out for Delivery</td>
                <td>LKR 850</td>
                <td>
                    <button class="btn view-btn">View Details</button>
                    <button class="btn track-btn">Track Order</button>
                    <button class="btn update-btn">Update Status</button>
                </td>
            </tr>
            <tr>
                <td>005</td>
                <td>Dinesh Wickramasinghe</td>
                <td>2025-07-21</td>
                <td><span class="vehicle-badge vehicle-lorry">Lorry</span></td>
                <td>Chaminda Silva</td>
                <td><span class="status out-delivery"></span>Out for Delivery</td>
                <td>LKR 4,200</td>
                <td>
                    <button class="btn view-btn">View Details</button>
                    <button class="btn track-btn">Track Order</button>
                    <button class="btn update-btn">Update Status</button>
                </td>
            </tr>
            <tr>
                <td>006</td>
                <td>Sanduni Rathnayake</td>
                <td>2025-07-22</td>
                <td><span class="vehicle-badge vehicle-bike">Bike</span></td>
                <td>Nuwan Bandara</td>
                <td><span class="status out-delivery"></span>Out for Delivery</td>
                <td>LKR 1,800</td>
                <td>
                    <button class="btn view-btn">View Details</button>
                    <button class="btn track-btn">Track Order</button>
                    <button class="btn update-btn">Update Status</button>
                </td>
            </tr>
        </tbody>
    </table>
</main>

</body>
</html>
