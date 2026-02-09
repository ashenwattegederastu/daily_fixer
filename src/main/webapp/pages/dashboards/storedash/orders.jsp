<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ page import="com.dailyfixer.model.User" %>
        <%@ page import="com.dailyfixer.dao.OrderDAO" %>
            <%@ page import="com.dailyfixer.model.Order" %>
                <%@ page import="com.dailyfixer.model.OrderItem" %>
                    <%@ page import="java.util.List" %>
                        <%@ page import="java.util.ArrayList" %>
                            <%@ page import="java.text.SimpleDateFormat" %>
                                <% User user=(User) session.getAttribute("currentUser"); if (user==null ||
                                    user.getRole()==null) { response.sendRedirect(request.getContextPath()
                                    + "/login.jsp" ); return; } String role=user.getRole().trim().toLowerCase(); if
                                    (!("admin".equals(role) || "store" .equals(role))) {
                                    response.sendRedirect(request.getContextPath() + "/login.jsp" ); return; } OrderDAO
                                    orderDAO=new OrderDAO(); String storeUsername=user.getUsername(); List<Order>
                                    allOrders = orderDAO.getOrdersByStatusAndStore("PAID", storeUsername);
                                    List<Order> orders = new ArrayList<>();
                                            if (allOrders != null) {
                                            for (Order order : allOrders) {
                                            String status = order.getStatus() != null ?
                                            order.getStatus().trim().toUpperCase() : "";
                                            if (!"DELIVERED".equals(status)) {
                                            orders.add(order);
                                            }
                                            }
                                            }
                                            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                                            %>
                                            <!DOCTYPE html>
                                            <html lang="en">

                                            <head>
                                                <meta charset="UTF-8">
                                                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                                <title>Orders | Daily Fixer</title>
                                                <style>
                                                    :root {
                                                        --background: #fafafa;
                                                        --foreground: #000;
                                                        --card: #fff;
                                                        --card-foreground: #000;
                                                        --primary: #7c3aed;
                                                        --primary-foreground: #fff;
                                                        --secondary: #e0e7ff;
                                                        --secondary-foreground: #1e1b4b;
                                                        --muted: #f3f4f6;
                                                        --muted-foreground: #6b7280;
                                                        --accent: #ede9fe;
                                                        --accent-foreground: #5b21b6;
                                                        --destructive: #dc2626;
                                                        --destructive-foreground: #fff;
                                                        --border: #e5e7eb;
                                                        --input: #e5e7eb;
                                                        --radius: 0.75rem;
                                                    }

                                                    * {
                                                        margin: 0;
                                                        padding: 0;
                                                        box-sizing: border-box;
                                                    }

                                                    body {
                                                        font-family: 'Segoe UI', sans-serif;
                                                        background-color: var(--background);
                                                        color: var(--foreground);
                                                        min-height: 100vh;
                                                        display: flex;
                                                    }

                                                    .topbar {
                                                        position: fixed;
                                                        top: 0;
                                                        left: 0;
                                                        right: 0;
                                                        height: 60px;
                                                        background-color: var(--card);
                                                        border-bottom: 1px solid var(--border);
                                                        display: flex;
                                                        justify-content: space-between;
                                                        align-items: center;
                                                        padding: 0 24px;
                                                        z-index: 200;
                                                    }

                                                    .topbar .logo {
                                                        font-size: 1.25em;
                                                        font-weight: 700;
                                                        color: var(--primary);
                                                    }

                                                    .topbar .panel-name {
                                                        font-weight: 600;
                                                        flex: 1;
                                                        text-align: center;
                                                    }

                                                    .topbar .logout-btn {
                                                        padding: 8px 16px;
                                                        background: var(--primary);
                                                        border: none;
                                                        color: var(--primary-foreground);
                                                        border-radius: var(--radius);
                                                        cursor: pointer;
                                                        font-weight: 600;
                                                        text-decoration: none;
                                                    }

                                                    .sidebar {
                                                        width: 220px;
                                                        background-color: var(--card);
                                                        height: 100vh;
                                                        position: fixed;
                                                        top: 0;
                                                        left: 0;
                                                        padding-top: 70px;
                                                        border-right: 1px solid var(--border);
                                                    }

                                                    .sidebar h3 {
                                                        padding: 0 16px 12px;
                                                        font-size: 0.8em;
                                                        color: var(--muted-foreground);
                                                        text-transform: uppercase;
                                                    }

                                                    .sidebar ul {
                                                        list-style: none;
                                                    }

                                                    .sidebar a {
                                                        display: block;
                                                        padding: 10px 16px;
                                                        text-decoration: none;
                                                        color: var(--foreground);
                                                        font-weight: 500;
                                                        border-left: 3px solid transparent;
                                                    }

                                                    .sidebar a:hover,
                                                    .sidebar a.active {
                                                        background-color: var(--accent);
                                                        color: var(--accent-foreground);
                                                        border-left-color: var(--primary);
                                                    }

                                                    .container {
                                                        flex: 1;
                                                        margin-left: 220px;
                                                        margin-top: 70px;
                                                        padding: 24px;
                                                    }

                                                    .container h2 {
                                                        font-size: 1.5em;
                                                        margin-bottom: 20px;
                                                    }

                                                    table {
                                                        width: 100%;
                                                        border-collapse: collapse;
                                                        background-color: var(--card);
                                                        border-radius: var(--radius);
                                                        overflow: hidden;
                                                        border: 1px solid var(--border);
                                                    }

                                                    table th,
                                                    table td {
                                                        padding: 12px 16px;
                                                        text-align: left;
                                                        border-bottom: 1px solid var(--border);
                                                    }

                                                    table th {
                                                        background-color: var(--muted);
                                                        font-weight: 600;
                                                    }

                                                    table tr:hover {
                                                        background-color: var(--accent);
                                                    }

                                                    .status {
                                                        display: inline-block;
                                                        width: 12px;
                                                        height: 12px;
                                                        border-radius: 50%;
                                                        margin-right: 8px;
                                                    }

                                                    .status.pending {
                                                        background-color: #f59e0b;
                                                    }

                                                    .status.processing {
                                                        background-color: #7c3aed;
                                                    }

                                                    .status.out-delivery {
                                                        background-color: #3b82f6;
                                                    }

                                                    .status.delivered {
                                                        background-color: #10b981;
                                                    }

                                                    .btn {
                                                        padding: 6px 12px;
                                                        border: none;
                                                        border-radius: var(--radius);
                                                        cursor: pointer;
                                                        font-size: 0.85rem;
                                                        font-weight: 500;
                                                        margin: 2px;
                                                    }

                                                    .view-btn {
                                                        background-color: var(--primary);
                                                        color: var(--primary-foreground);
                                                    }

                                                    .update-btn {
                                                        background-color: var(--secondary);
                                                        color: var(--secondary-foreground);
                                                    }

                                                    .delivery-btn {
                                                        background-color: var(--destructive);
                                                        color: var(--destructive-foreground);
                                                    }

                                                    .btn:hover {
                                                        opacity: 0.9;
                                                    }

                                                    .status-options {
                                                        display: none;
                                                        position: absolute;
                                                        background: var(--card);
                                                        border: 1px solid var(--border);
                                                        border-radius: var(--radius);
                                                        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
                                                        z-index: 1000;
                                                        min-width: 150px;
                                                    }

                                                    .status-options button {
                                                        display: block;
                                                        width: 100%;
                                                        padding: 8px 12px;
                                                        border: none;
                                                        background: none;
                                                        text-align: left;
                                                        cursor: pointer;
                                                    }

                                                    .status-options button:hover {
                                                        background-color: var(--accent);
                                                    }

                                                    .vehicle-modal {
                                                        display: none;
                                                        position: fixed;
                                                        top: 0;
                                                        left: 0;
                                                        width: 100%;
                                                        height: 100%;
                                                        background: rgba(0, 0, 0, 0.5);
                                                        justify-content: center;
                                                        align-items: center;
                                                        z-index: 500;
                                                    }

                                                    .vehicle-modal .modal-content {
                                                        background: var(--card);
                                                        padding: 24px;
                                                        border-radius: var(--radius);
                                                        max-width: 400px;
                                                        width: 90%;
                                                        text-align: center;
                                                        position: relative;
                                                    }

                                                    .vehicle-modal h3 {
                                                        color: var(--primary);
                                                        margin-bottom: 16px;
                                                    }

                                                    .vehicle-options {
                                                        display: grid;
                                                        grid-template-columns: repeat(2, 1fr);
                                                        gap: 10px;
                                                        margin-bottom: 16px;
                                                    }

                                                    .vehicle-btn {
                                                        padding: 12px;
                                                        border: 2px solid var(--border);
                                                        border-radius: var(--radius);
                                                        background: var(--card);
                                                        cursor: pointer;
                                                        font-weight: 500;
                                                    }

                                                    .vehicle-btn:hover,
                                                    .vehicle-btn.selected {
                                                        border-color: var(--primary);
                                                        background: var(--accent);
                                                    }

                                                    .modal-buttons {
                                                        display: flex;
                                                        gap: 10px;
                                                        justify-content: center;
                                                    }

                                                    .modal-btn {
                                                        padding: 10px 20px;
                                                        border: none;
                                                        border-radius: var(--radius);
                                                        cursor: pointer;
                                                        font-weight: 500;
                                                    }

                                                    .confirm-btn {
                                                        background: var(--primary);
                                                        color: var(--primary-foreground);
                                                    }

                                                    .cancel-btn {
                                                        background: var(--secondary);
                                                        color: var(--secondary-foreground);
                                                    }

                                                    .close-btn {
                                                        position: absolute;
                                                        top: 12px;
                                                        right: 16px;
                                                        font-size: 1.5em;
                                                        cursor: pointer;
                                                        color: var(--muted-foreground);
                                                        background: none;
                                                        border: none;
                                                    }

                                                    .order-details-modal {
                                                        display: none;
                                                        position: fixed;
                                                        top: 0;
                                                        left: 0;
                                                        width: 100%;
                                                        height: 100%;
                                                        background: rgba(0, 0, 0, 0.5);
                                                        z-index: 1000;
                                                        justify-content: center;
                                                        align-items: center;
                                                    }

                                                    .order-details-modal.active {
                                                        display: flex;
                                                    }

                                                    .order-details-content {
                                                        background: var(--card);
                                                        border-radius: var(--radius);
                                                        padding: 24px;
                                                        max-width: 500px;
                                                        width: 90%;
                                                        max-height: 80vh;
                                                        overflow-y: auto;
                                                        position: relative;
                                                    }

                                                    .order-details-content h3 {
                                                        color: var(--primary);
                                                        margin-bottom: 16px;
                                                        border-bottom: 2px solid var(--border);
                                                        padding-bottom: 8px;
                                                    }

                                                    .detail-row {
                                                        display: flex;
                                                        justify-content: space-between;
                                                        padding: 8px 0;
                                                        border-bottom: 1px solid var(--border);
                                                    }

                                                    .detail-label {
                                                        font-weight: 600;
                                                        color: var(--muted-foreground);
                                                    }

                                                    .detail-value {
                                                        color: var(--foreground);
                                                    }
                                                </style>
                                            </head>

                                            <body>
                                                <header class="topbar">
                                                    <div class="logo">Daily Fixer</div>
                                                    <div class="panel-name">Store Panel</div>
                                                    <a href="${pageContext.request.contextPath}/logout"
                                                        class="logout-btn">Log Out</a>
                                                </header>
                                                <aside class="sidebar">
                                                    <h3>Navigation</h3>
                                                    <ul>
                                                        <li><a
                                                                href="${pageContext.request.contextPath}/pages/dashboards/storedash/storedashmain.jsp">Dashboard</a>
                                                        </li>
                                                        <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/orders.jsp"
                                                                class="active">Orders</a></li>
                                                        <li><a
                                                                href="${pageContext.request.contextPath}/pages/dashboards/storedash/upfordelivery.jsp">Up
                                                                for Delivery</a></li>
                                                        <li><a
                                                                href="${pageContext.request.contextPath}/pages/dashboards/storedash/completedorders.jsp">Completed
                                                                Orders</a></li>
                                                        <li><a
                                                                href="${pageContext.request.contextPath}/ListProductsServlet">Catalogue</a>
                                                        </li>
                                                        <li><a
                                                                href="${pageContext.request.contextPath}/ListDiscountsServlet">Discounts</a>
                                                        </li>
                                                        <li><a
                                                                href="${pageContext.request.contextPath}/StoreReviewsServlet">Customer
                                                                Reviews</a></li>
                                                        <li><a
                                                                href="${pageContext.request.contextPath}/pages/dashboards/storedash/myProfile.jsp">Profile</a>
                                                        </li>
                                                    </ul>
                                                </aside>
                                                <main class="container">
                                                    <h2>Orders</h2>
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
                                                            <% if (orders==null || orders.isEmpty()) { %>
                                                                <tr>
                                                                    <td colspan="6"
                                                                        style="text-align: center; padding: 30px; color: #666;">
                                                                        No paid orders found. Orders will appear here
                                                                        after successful payment.
                                                                    </td>
                                                                </tr>
                                                                <% } else { int orderIndex=1; for (Order order : orders)
                                                                    { String orderId=order.getOrderId(); String
                                                                    customerName=order.getFirstName(); if
                                                                    (order.getLastName() !=null &&
                                                                    !order.getLastName().isEmpty()) {
                                                                    customerName=customerName + " " +
                                                                    order.getLastName(); } String
                                                                    orderDate=order.getCreatedAt() !=null ?
                                                                    dateFormat.format(order.getCreatedAt()) : "N/A" ;
                                                                    String dbStatus=order.getStatus() !=null ?
                                                                    order.getStatus().trim().toUpperCase() : "PENDING" ;
                                                                    String displayStatus="Pending" ; String
                                                                    statusClass="pending" ; if
                                                                    ("PENDING".equals(dbStatus)) {
                                                                    displayStatus="Pending" ; statusClass="pending" ; }
                                                                    else if ("PROCESSING".equals(dbStatus)) {
                                                                    displayStatus="Processing" ;
                                                                    statusClass="processing" ; } else if
                                                                    ("OUT_FOR_DELIVERY".equals(dbStatus)
                                                                    || "OUT FOR DELIVERY" .equals(dbStatus)) {
                                                                    displayStatus="Out for Delivery" ;
                                                                    statusClass="out-delivery" ; } else if
                                                                    ("DELIVERED".equals(dbStatus)) {
                                                                    displayStatus="Delivered" ; statusClass="delivered"
                                                                    ; } else if ("PAID".equals(dbStatus)) {
                                                                    displayStatus="Pending" ; statusClass="pending" ; }
                                                                    String totalAmount=String.format("LKR %.2f",
                                                                    order.getAmount()); String
                                                                    escapedCustomerName=customerName.replace("'", "\\'"
                                                                    ); String escapedAddress=order.getAddress() !=null ?
                                                                    order.getAddress().replace("'", "\\'" ) : "" ;
                                                                    String escapedCity=order.getCity() !=null ?
                                                                    order.getCity().replace("'", "\\'" ) : "" ; String
                                                                    escapedPhone=order.getPhone() !=null ?
                                                                    order.getPhone().replace("'", "\\'" ) : "" ; String
                                                                    escapedEmail=order.getEmail() !=null ?
                                                                    order.getEmail().replace("'", "\\'" ) : "" ;
                                                                    List<OrderItem> orderItems =
                                                                    orderDAO.getOrderItemsByOrderId(orderId);
                                                                    StringBuilder itemsJson = new StringBuilder();
                                                                    itemsJson.append("[");
                                                                    if (orderItems != null && !orderItems.isEmpty()) {
                                                                    for (int i = 0; i < orderItems.size(); i++) {
                                                                        OrderItem item=orderItems.get(i); if (i> 0)
                                                                        itemsJson.append(",");
                                                                        String pName = item.getProductName() != null ?
                                                                        item.getProductName().replace("\\",
                                                                        "\\\\").replace("\"", "\\\"") : "";
                                                                        itemsJson.append("{\"productName\":\"").append(pName).append("\",");
                                                                        itemsJson.append("\"quantity\":").append(item.getQuantity()).append(",");
                                                                        itemsJson.append("\"unitPrice\":").append(item.getUnitPrice()).append(",");
                                                                        itemsJson.append("\"totalPrice\":").append(item.getTotalPrice()).append("}");
                                                                        }
                                                                        }
                                                                        itemsJson.append("]");
                                                                        String orderItemsJsonStr = itemsJson.toString();
                                                                        %>
                                                                        <tr>
                                                                            <td>
                                                                                <%= orderId %>
                                                                            </td>
                                                                            <td>
                                                                                <%= customerName %>
                                                                            </td>
                                                                            <td>
                                                                                <%= orderDate %>
                                                                            </td>
                                                                            <td id="status-<%= orderIndex %>"><span
                                                                                    class="status <%= statusClass %>"></span>
                                                                                <%= displayStatus %>
                                                                            </td>
                                                                            <td>
                                                                                <%= totalAmount %>
                                                                            </td>
                                                                            <td>
                                                                                <button class="btn view-btn"
                                                                                    data-order-id="<%= orderId %>"
                                                                                    data-customer-name="<%= escapedCustomerName %>"
                                                                                    data-total="<%= totalAmount %>"
                                                                                    data-address="<%= escapedAddress %>"
                                                                                    data-city="<%= escapedCity %>"
                                                                                    data-phone="<%= escapedPhone %>"
                                                                                    data-email="<%= escapedEmail %>"
                                                                                    data-order-date="<%= orderDate %>"
                                                                                    data-order-items='<%= orderItemsJsonStr %>'
                                                                                    onclick="showOrderDetailsModalFromButton(this)">View
                                                                                    Details</button>
                                                                                <button class="btn update-btn"
                                                                                    onclick="toggleStatusOptions(this, <%= orderIndex %>)">Update
                                                                                    Status</button>
                                                                                <div class="status-options"
                                                                                    id="status-options-<%= orderIndex %>">
                                                                                    <button
                                                                                        onclick="changeStatus(this, 'PENDING', '<%= orderId %>', <%= orderIndex %>)">Pending</button>
                                                                                    <button
                                                                                        onclick="changeStatus(this, 'PROCESSING', '<%= orderId %>', <%= orderIndex %>)">Processing</button>
                                                                                    <button
                                                                                        onclick="changeStatus(this, 'OUT_FOR_DELIVERY', '<%= orderId %>', <%= orderIndex %>)">Out
                                                                                        for Delivery</button>
                                                                                    <button
                                                                                        onclick="changeStatus(this, 'DELIVERED', '<%= orderId %>', <%= orderIndex %>)">Delivered</button>
                                                                                </div>
                                                                                <button class="btn delivery-btn"
                                                                                    onclick="showVehicleModal('<%= orderId %>')">Ready
                                                                                    to Deliver</button>
                                                                            </td>
                                                                        </tr>
                                                                        <% orderIndex++; } } %>
                                                        </tbody>
                                                    </table>
                                                </main>
                                                <div id="orderDetailsModal" class="order-details-modal">
                                                    <div class="order-details-content">
                                                        <button class="close-btn"
                                                            onclick="closeOrderDetailsModal()">&times;</button>
                                                        <h3>Order Details</h3>
                                                        <div class="detail-row"><span class="detail-label">Order
                                                                ID:</span><span class="detail-value"
                                                                id="modal-order-id">-</span></div>
                                                        <div class="detail-row"><span class="detail-label">Order
                                                                Date:</span><span class="detail-value"
                                                                id="modal-order-date">-</span></div>
                                                        <div class="detail-row"><span
                                                                class="detail-label">Customer:</span><span
                                                                class="detail-value" id="modal-customer-name">-</span>
                                                        </div>
                                                        <div class="detail-row"><span
                                                                class="detail-label">Phone:</span><span
                                                                class="detail-value" id="modal-phone">-</span></div>
                                                        <div class="detail-row"><span
                                                                class="detail-label">Email:</span><span
                                                                class="detail-value" id="modal-email">-</span></div>
                                                        <div class="detail-row"><span
                                                                class="detail-label">Address:</span><span
                                                                class="detail-value" id="modal-address">-</span></div>
                                                        <div class="detail-row"><span
                                                                class="detail-label">City:</span><span
                                                                class="detail-value" id="modal-city">-</span></div>
                                                        <div style="padding: 8px 0;"><span
                                                                class="detail-label">Products:</span>
                                                            <div id="modal-products" style="margin-top: 8px;">-</div>
                                                        </div>
                                                        <div class="detail-row"><span
                                                                class="detail-label">Total:</span><span
                                                                class="detail-value" id="modal-total"
                                                                style="font-weight: 700; color: var(--primary);">-</span>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div id="vehicleModal" class="vehicle-modal">
                                                    <div class="modal-content">
                                                        <button class="close-btn"
                                                            onclick="closeVehicleModal()">&times;</button>
                                                        <h3>Select Delivery Vehicle</h3>
                                                        <p>Choose the type of vehicle needed for delivery:</p>
                                                        <div class="vehicle-options">
                                                            <button class="vehicle-btn"
                                                                onclick="selectVehicle('bike')">Bike</button>
                                                            <button class="vehicle-btn"
                                                                onclick="selectVehicle('threewheel')">Three
                                                                Wheel</button>
                                                            <button class="vehicle-btn"
                                                                onclick="selectVehicle('lorry')">Lorry</button>
                                                        </div>
                                                        <div class="modal-buttons">
                                                            <button class="modal-btn confirm-btn"
                                                                onclick="confirmDelivery()">Confirm</button>
                                                            <button class="modal-btn cancel-btn"
                                                                onclick="closeVehicleModal()">Cancel</button>
                                                        </div>
                                                    </div>
                                                </div>
                                                <script>
                                                    let selectedOrderId = '';
                                                    let selectedVehicle = '';

                                                    function toggleStatusOptions(btn, orderIndex) {
                                                        document.querySelectorAll('.status-options').forEach(function (div) {
                                                            if (div.id !== 'status-options-' + orderIndex) div.style.display = 'none';
                                                        });
                                                        var optionsDiv = document.getElementById('status-options-' + orderIndex);
                                                        if (optionsDiv) {
                                                            optionsDiv.style.display = optionsDiv.style.display === 'block' ? 'none' : 'block';
                                                        }
                                                    }

                                                    function showOrderDetailsModalFromButton(button) {
                                                        var orderId = button.getAttribute('data-order-id') || '-';
                                                        var customerName = button.getAttribute('data-customer-name') || '-';
                                                        var total = button.getAttribute('data-total') || '-';
                                                        var address = button.getAttribute('data-address') || '-';
                                                        var city = button.getAttribute('data-city') || '-';
                                                        var phone = button.getAttribute('data-phone') || '-';
                                                        var email = button.getAttribute('data-email') || '-';
                                                        var orderDate = button.getAttribute('data-order-date') || '-';
                                                        var orderItemsJson = button.getAttribute('data-order-items') || '[]';
                                                        var orderItems = [];
                                                        try { orderItems = JSON.parse(orderItemsJson); } catch (e) { orderItems = []; }
                                                        document.getElementById('modal-order-id').textContent = orderId;
                                                        document.getElementById('modal-order-date').textContent = orderDate;
                                                        document.getElementById('modal-customer-name').textContent = customerName;
                                                        document.getElementById('modal-phone').textContent = phone;
                                                        document.getElementById('modal-email').textContent = email;
                                                        document.getElementById('modal-address').textContent = address;
                                                        document.getElementById('modal-city').textContent = city;
                                                        var productsContainer = document.getElementById('modal-products');
                                                        if (orderItems && orderItems.length > 0) {
                                                            var html = '';
                                                            orderItems.forEach(function (item) {
                                                                html += '<div style="padding: 6px; background: #f3f4f6; border-radius: 6px; margin-bottom: 6px;">';
                                                                html += '<strong>' + (item.productName || '-') + '</strong><br>';
                                                                html += 'Qty: ' + (item.quantity || 0) + ' x LKR ' + parseFloat(item.unitPrice || 0).toFixed(2);
                                                                html += '</div>';
                                                            });
                                                            productsContainer.innerHTML = html;
                                                        } else {
                                                            productsContainer.innerHTML = '-';
                                                        }
                                                        document.getElementById('modal-total').textContent = total;
                                                        document.getElementById('orderDetailsModal').classList.add('active');
                                                    }

                                                    function closeOrderDetailsModal() {
                                                        document.getElementById('orderDetailsModal').classList.remove('active');
                                                    }

                                                    document.getElementById('orderDetailsModal').addEventListener('click', function (e) {
                                                        if (e.target.id === 'orderDetailsModal') closeOrderDetailsModal();
                                                    });

                                                    function changeStatus(button, newStatus, orderId, orderIndex) {
                                                        var statusMap = {
                                                            'PENDING': { text: 'Pending', cssClass: 'pending' },
                                                            'PROCESSING': { text: 'Processing', cssClass: 'processing' },
                                                            'OUT_FOR_DELIVERY': { text: 'Out for Delivery', cssClass: 'out-delivery' },
                                                            'DELIVERED': { text: 'Delivered', cssClass: 'delivered' }
                                                        };
                                                        var statusInfo = statusMap[newStatus] || { text: newStatus, cssClass: 'pending' };
                                                        var statusCell = document.getElementById('status-' + orderIndex);
                                                        if (statusCell) {
                                                            statusCell.innerHTML = '<span class="status ' + statusInfo.cssClass + '"></span> ' + statusInfo.text;
                                                        }
                                                        button.parentElement.style.display = 'none';
                                                        var contextPath = '<%= request.getContextPath() %>';
                                                        fetch(contextPath + '/UpdateOrderStatusServlet', {
                                                            method: 'POST',
                                                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                                            body: 'orderId=' + encodeURIComponent(orderId) + '&status=' + encodeURIComponent(newStatus)
                                                        }).then(function (response) {
                                                            return response.json();
                                                        }).then(function (data) {
                                                            if (data.success) {
                                                                if (newStatus === 'DELIVERED') {
                                                                    setTimeout(function () { window.location.reload(); }, 1000);
                                                                }
                                                            } else {
                                                                alert('Failed to update status');
                                                                window.location.reload();
                                                            }
                                                        }).catch(function (error) {
                                                            alert('Error updating status');
                                                            window.location.reload();
                                                        });
                                                    }

                                                    function showVehicleModal(orderId) {
                                                        selectedOrderId = orderId;
                                                        document.getElementById('vehicleModal').style.display = 'flex';
                                                    }

                                                    function closeVehicleModal() {
                                                        document.getElementById('vehicleModal').style.display = 'none';
                                                        selectedVehicle = '';
                                                        document.querySelectorAll('.vehicle-btn').forEach(function (btn) {
                                                            btn.classList.remove('selected');
                                                        });
                                                    }

                                                    function selectVehicle(vehicle) {
                                                        selectedVehicle = vehicle;
                                                        document.querySelectorAll('.vehicle-btn').forEach(function (btn) {
                                                            btn.classList.remove('selected');
                                                        });
                                                        event.target.classList.add('selected');
                                                    }

                                                    function confirmDelivery() {
                                                        if (selectedVehicle) {
                                                            var vehicleMap = { 'bike': 'Bike', 'threewheel': 'Three Wheeler', 'lorry': 'Lorry' };
                                                            var vehicleCategory = vehicleMap[selectedVehicle];
                                                            if (!vehicleCategory) { alert('Invalid vehicle type'); return; }
                                                            var confirmBtn = document.querySelector('.confirm-btn');
                                                            if (confirmBtn) { confirmBtn.disabled = true; confirmBtn.textContent = 'Processing...'; }
                                                            var contextPath = '<%= request.getContextPath() %>';
                                                            fetch(contextPath + '/AssignDeliveryServlet', {
                                                                method: 'POST',
                                                                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                                                body: 'orderId=' + encodeURIComponent(selectedOrderId) + '&vehicleCategory=' + encodeURIComponent(vehicleCategory)
                                                            }).then(function (response) {
                                                                closeVehicleModal();
                                                                window.location.href = contextPath + '/StoreUpForDeliveryServlet';
                                                            }).catch(function (error) {
                                                                alert('Error assigning delivery');
                                                                closeVehicleModal();
                                                                if (confirmBtn) { confirmBtn.disabled = false; confirmBtn.textContent = 'Confirm'; }
                                                            });
                                                        } else {
                                                            alert('Please select a delivery vehicle type.');
                                                        }
                                                    }

                                                    document.getElementById('vehicleModal').addEventListener('click', function (e) {
                                                        if (e.target.id === 'vehicleModal') closeVehicleModal();
                                                    });
                                                </script>
                                            </body>

                                            </html>