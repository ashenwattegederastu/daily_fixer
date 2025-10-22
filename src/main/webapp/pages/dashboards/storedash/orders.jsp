<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daily Fixer</title>
    <!-- Link to external stylesheet -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/view_orders.css">
</head>
<body>
<header>

    <!-- Main Navbar -->
    <nav class="navbar">
        <div class="logo">Daily Fixer</div>
        <ul class="nav-links">
            <li><a href="${pageContext.request.contextPath}" class="active">Home</a></li>
            <li><a href="${pageContext.request.contextPath}/logout">Log out</a></li>
        </ul>
    </nav>

    <!-- Rounded Subnav -->
    <nav class="subnav">
        <div class="store-name">MyStore</div>
        <ul>
            <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/storedashmain.jsp">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/orders.jsp" class="active">Orders</a></li>
            <li><a href="${pageContext.request.contextPath}/ListProductsServlet"  >Catalogue</a></li>
            <%--            <li><a href="#">Orders</a></li>--%>
            <%--      <li><a href="#">Set Rates</a></li>--%>
            <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/myProfile.jsp">Profile</a></li>
        </ul>
    </nav>
</header>

<main>
    <h2>View Orders</h2>
    <div class="status-legend">
        <span class="status pending"></span> Pending
        <span class="status out-delivery"></span> Out for Delivery
        <span class="status delivered"></span> Delivered
    </div>

    <table>
        <thead>
        <tr>
            <th>Order ID</th>
            <th>Customer</th>
            <th>Date</th>
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
            <td><span class="status pending"></span>Pending</td>
            <td>LKR 1,100</td>
            <td>
                <button class="btn view">View Details</button>
                <button class="btn update" onclick="toggleStatusOptions(this, 1)">Update Status</button>
                <div class="status-options" id="status-options-1">
                    <button onclick="changeStatus(this, 'Pending')">Pending</button>
                    <button onclick="changeStatus(this, 'Out for Delivery')">Out for Delivery</button>
                    <button onclick="changeStatus(this, 'Delivered')">Delivered</button>
                </div>
                <button class="btn delivery-btn" style="display:none;" onclick="goToDeliveryPage()">Find a Delivery</button>
            </td>
        </tr>
        <tr>
            <td>002</td>
            <td>Amal Bandara</td>
            <td>2025-07-06</td>
            <td><span class="status delivered"></span>Delivered</td>
            <td>LKR 350</td>
            <td>
                <button class="btn view">View Details</button>
                <button class="btn update" onclick="toggleStatusOptions(this, 2)">Update Status</button>
                <div class="status-options" id="status-options-2">
                    <button onclick="changeStatus(this, 'Pending')">Pending</button>
                    <button onclick="changeStatus(this, 'Out for Delivery')">Out for Delivery</button>
                    <button onclick="changeStatus(this, 'Delivered')">Delivered</button>
                </div>
                <button class="btn delivery-btn" style="display:none;" onclick="goToDeliveryPage()">Find a Delivery</button>
            </td>
        </tr>
        </tbody>
    </table>
</main>
<script>
    function toggleStatusOptions(btn, orderId) {
        const optionsDiv = document.getElementById(`status-options-${orderId}`);
        optionsDiv.style.display =
            optionsDiv.style.display === "block" ? "none" : "block";
    }

    function changeStatus(button, newStatus) {
        const row = button.closest("tr");
        const statusCell = row.querySelector("td:nth-child(4)");
        const deliveryBtn = row.querySelector(".delivery-btn");

        // Update status visually
        let statusClass = "";
        if (newStatus === "Pending") statusClass = "pending";
        if (newStatus === "Out for Delivery") statusClass = "out-delivery";
        if (newStatus === "Delivered") statusClass = "delivered";

        statusCell.innerHTML = `<span class="status ${statusClass}"></span> ${newStatus}`;

        // Show/hide Find a Delivery button
        if (deliveryBtn) {
            if (newStatus === "Pending") {
                deliveryBtn.style.display = "inline-block";
            } else {
                deliveryBtn.style.display = "none";
            }
        }

        // Hide status options
        button.parentElement.style.display = "none";
    }

    function goToDeliveryPage() {
        // Replace 'find_delivery.html' with the actual page you want
        window.location.href = "find_delivery.html";
    }
</script>


</body>
</html>
