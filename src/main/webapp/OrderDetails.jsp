<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.dailyfixer.dao.OrderDAO" %>
<%@ page import="com.dailyfixer.dao.StoreDAO" %>
<%@ page import="com.dailyfixer.dao.UserDAO" %>
<%@ page import="com.dailyfixer.dao.UserNotificationDAO" %>
<%@ page import="com.dailyfixer.model.Order" %>
<%@ page import="com.dailyfixer.model.OrderItem" %>
<%@ page import="com.dailyfixer.model.Store" %>
<%@ page import="com.dailyfixer.model.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null || currentUser.getRole() == null || !"user".equalsIgnoreCase(currentUser.getRole().trim())) {
        response.sendRedirect(request.getContextPath() + "/pages/shared/login.jsp");
        return;
    }
    String orderIdParam = request.getParameter("order_id");
    if (orderIdParam == null || orderIdParam.trim().isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/pages/dashboards/userdash/notifications.jsp");
        return;
    }
    OrderDAO orderDAO = new OrderDAO();
    Order order = orderDAO.findOrderById(orderIdParam);
    if (order == null) {
        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Order not found");
        return;
    }
    if (!"PAID".equalsIgnoreCase(order.getStatus() != null ? order.getStatus().trim() : "")) {
        response.sendRedirect(request.getContextPath() + "/pages/dashboards/userdash/notifications.jsp");
        return;
    }
    boolean emailMatch = currentUser.getEmail() != null && order.getEmail() != null
            && currentUser.getEmail().trim().equalsIgnoreCase(order.getEmail().trim());
    UserNotificationDAO notifDAO = new UserNotificationDAO();
    boolean hasNotification = notifDAO.existsOrderSuccessNotificationForUser(currentUser.getUserId(), orderIdParam);
    if (!emailMatch && !hasNotification) {
        response.sendError(HttpServletResponse.SC_FORBIDDEN, "You do not have access to this order");
        return;
    }

    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
    String customerName = order.getFirstName() + (order.getLastName() != null && !order.getLastName().isEmpty() ? " " + order.getLastName() : "");
    String orderDate = order.getCreatedAt() != null ? dateFormat.format(order.getCreatedAt()) : "N/A";
    String totalAmount = String.format("LKR %.2f", order.getAmount() != null ? order.getAmount() : 0);

    List<OrderItem> allOrderItems = orderDAO.getOrderItemsByOrderId(orderIdParam);
    if (allOrderItems == null) allOrderItems = new ArrayList<>();
    Map<Integer, Map<String, String>> storeInfoMap = new HashMap<>();
    StoreDAO storeDAO = new StoreDAO();
    UserDAO userDAO = new UserDAO();
    for (OrderItem item : allOrderItems) {
        int storeId = item.getStoreId();
        if (!storeInfoMap.containsKey(storeId)) {
            try {
                Store store = storeDAO.getStoreById(storeId);
                if (store != null) {
                    Map<String, String> storeInfo = new HashMap<>();
                    storeInfo.put("storeName", store.getStoreName() != null ? store.getStoreName() : "N/A");
                    storeInfo.put("storeAddress", store.getStoreAddress() != null ? store.getStoreAddress() : "N/A");
                    storeInfo.put("storeCity", store.getStoreCity() != null ? store.getStoreCity() : "N/A");
                    try {
                        User storeOwner = userDAO.getUserById(store.getUserId());
                        storeInfo.put("contact", storeOwner != null && storeOwner.getPhoneNumber() != null ? storeOwner.getPhoneNumber() : "N/A");
                        storeInfo.put("email", storeOwner != null && storeOwner.getEmail() != null ? storeOwner.getEmail() : "N/A");
                    } catch (Exception e) {
                        storeInfo.put("contact", "N/A");
                        storeInfo.put("email", "N/A");
                    }
                    storeInfoMap.put(storeId, storeInfo);
                }
            } catch (Exception e) {
                // skip store
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Details - <%= order.getOrderId() %></title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
:root {
  --primary: #8b7dd8;
  --primary-foreground: #fff;
  --foreground: #111;
  --border: #e0e0e0;
  --success: #27ae60;
  --card: #f9f9f9;
  --muted-foreground: #666;
  --radius-md: 12px;
  --radius-sm: 8px;
  --shadow-sm: 0 2px 8px rgba(0,0,0,0.08);
  --shadow-md: 0 4px 16px rgba(0,0,0,0.12);
}
* { margin: 0; padding: 0; box-sizing: border-box; }
body { font-family: 'Inter', sans-serif; background: #f5f5f5; color: var(--foreground); padding: 20px; }
.nav { max-width: 800px; margin: 0 auto 20px; display: flex; justify-content: space-between; align-items: center; }
.nav a { color: var(--primary); font-weight: 600; text-decoration: none; }
.nav a:hover { text-decoration: underline; }
.result-card { max-width: 800px; margin: 0 auto; background: #fff; border-radius: var(--radius-md); box-shadow: var(--shadow-md); padding: 2rem; }
.result-card h1 { color: var(--primary); margin-bottom: 0.5rem; font-size: 1.5rem; }
.result-card .subtitle { color: var(--muted-foreground); margin-bottom: 1.5rem; }
.order-section { margin-bottom: 1.5rem; }
.section-title { font-size: 1.1rem; font-weight: 700; color: var(--primary); margin-bottom: 0.75rem; padding-bottom: 0.5rem; border-bottom: 2px solid var(--border); }
.detail-row { display: flex; justify-content: space-between; align-items: center; padding: 0.75rem 0; border-bottom: 1px solid var(--border); }
.detail-row:last-child { border-bottom: none; }
.detail-label { font-weight: 600; color: var(--foreground); font-size: 0.95rem; }
.detail-value { font-weight: 500; color: var(--foreground); font-size: 0.95rem; text-align: right; max-width: 60%; word-wrap: break-word; }
.status-paid { display: inline-block; padding: 0.5rem 1rem; background: var(--success); color: white; border-radius: var(--radius-md); font-weight: 600; font-size: 0.85rem; text-transform: uppercase; }
.amount-highlight { font-size: 1.3rem; font-weight: 700; color: var(--primary); }
.product-item { padding: 0.75rem; background: var(--card); border-radius: var(--radius-sm); border-left: 3px solid var(--primary); margin-bottom: 0.5rem; }
.product-item-name { font-weight: 600; color: var(--foreground); margin-bottom: 0.25rem; }
.product-item-details { font-size: 0.9em; color: var(--muted-foreground); }
.action-buttons { display: flex; gap: 1rem; margin-top: 2rem; flex-wrap: wrap; }
.btn-primary, .btn-secondary { padding: 0.75rem 1.5rem; border: none; border-radius: var(--radius-md); font-size: 1rem; font-weight: 600; cursor: pointer; text-decoration: none; display: inline-flex; align-items: center; gap: 0.5rem; transition: all 0.2s; }
.btn-primary { background: var(--primary); color: var(--primary-foreground); }
.btn-primary:hover { opacity: 0.9; transform: translateY(-1px); }
.btn-secondary { background: #e0e0e0; color: #333; }
.btn-secondary:hover { background: #d0d0d0; }
.btn-download { background: var(--success); color: white; }
.btn-download:hover { opacity: 0.9; transform: translateY(-1px); }
@media print { .nav, .action-buttons { display: none !important; } }
    </style>
</head>
<body>
    <div class="nav">
        <a href="${pageContext.request.contextPath}/pages/dashboards/userdash/notifications.jsp">← Back to Notifications</a>
        <a href="${pageContext.request.contextPath}/pages/dashboards/userdash/userdashmain.jsp">Dashboard</a>
    </div>
    <main class="result-card">
        <h1>Your order is successful</h1>
        <p class="subtitle">Order <%= order.getOrderId() %> — view details below and download your receipt.</p>

        <div class="order-details" id="orderDetails">
            <div class="order-section">
                <div class="section-title">Order Information</div>
                <div class="detail-row">
                    <span class="detail-label">Order ID</span>
                    <span class="detail-value"><%= order.getOrderId() %></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Order Date</span>
                    <span class="detail-value"><%= orderDate %></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Payment Status</span>
                    <span class="status-paid">PAID</span>
                </div>
            </div>

            <div class="order-section">
                <div class="section-title">Customer Information</div>
                <div class="detail-row">
                    <span class="detail-label">Name</span>
                    <span class="detail-value"><%= customerName %></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Email</span>
                    <span class="detail-value"><%= order.getEmail() != null ? order.getEmail() : "N/A" %></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Phone</span>
                    <span class="detail-value"><%= order.getPhone() != null ? order.getPhone() : "N/A" %></span>
                </div>
            </div>

            <div class="order-section">
                <div class="section-title">Delivery Information</div>
                <div class="detail-row">
                    <span class="detail-label">Address</span>
                    <span class="detail-value"><%= order.getAddress() != null ? order.getAddress() : "N/A" %></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">City</span>
                    <span class="detail-value"><%= order.getCity() != null ? order.getCity() : "N/A" %></span>
                </div>
            </div>

            <% if (!storeInfoMap.isEmpty()) { %>
            <div class="order-section">
                <div class="section-title">Store Information</div>
                <% int storeIndex = 0;
                   for (Map.Entry<Integer, Map<String, String>> storeEntry : storeInfoMap.entrySet()) {
                       Map<String, String> storeInfo = storeEntry.getValue();
                       storeIndex++;
                %>
                <% if (storeInfoMap.size() > 1) { %><div style="margin-bottom: 1rem; padding-bottom: 1rem; border-bottom: 1px solid var(--border);"><div style="font-weight: 600; color: var(--primary); margin-bottom: 0.5rem;">Store <%= storeIndex %></div><% } %>
                <div class="detail-row"><span class="detail-label">Store Name</span><span class="detail-value"><%= storeInfo.get("storeName") %></span></div>
                <div class="detail-row"><span class="detail-label">Store Address</span><span class="detail-value"><%= storeInfo.get("storeAddress") %></span></div>
                <div class="detail-row"><span class="detail-label">Store City</span><span class="detail-value"><%= storeInfo.get("storeCity") %></span></div>
                <div class="detail-row"><span class="detail-label">Contact</span><span class="detail-value"><%= storeInfo.get("contact") %></span></div>
                <div class="detail-row"><span class="detail-label">Email</span><span class="detail-value"><%= storeInfo.get("email") %></span></div>
                <% if (storeInfoMap.size() > 1 && storeIndex < storeInfoMap.size()) { %></div><% } %>
                <% } %>
            </div>
            <% } %>

            <div class="order-section">
                <div class="section-title">Order Summary</div>
                <div class="detail-row" style="flex-direction: column; align-items: flex-start;">
                    <span class="detail-label" style="margin-bottom: 10px;">Products</span>
                    <div style="width: 100%;">
                        <% if (allOrderItems.isEmpty()) { %>
                        <span class="detail-value"><%= order.getProductName() != null ? order.getProductName() : "N/A" %></span>
                        <% } else { %>
                        <% for (OrderItem item : allOrderItems) { %>
                        <div class="product-item">
                            <div class="product-item-name"><%= item.getProductName() %></div>
                            <div class="product-item-details">Quantity: <%= item.getQuantity() %> × LKR <%= String.format("%.2f", item.getUnitPrice()) %> = LKR <%= String.format("%.2f", item.getTotalPrice()) %></div>
                        </div>
                        <% } %>
                        <% } %>
                    </div>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Total Amount</span>
                    <span class="detail-value amount-highlight"><%= totalAmount %></span>
                </div>
            </div>
        </div>

        <div class="action-buttons">
            <button type="button" onclick="downloadReceipt()" class="btn-primary btn-download">📄 Download Receipt</button>
            <a href="${pageContext.request.contextPath}/pages/dashboards/userdash/notifications.jsp" class="btn-secondary">← Back to Notifications</a>
        </div>
    </main>

    <script>
        function downloadReceipt() {
            const printWindow = window.open('', '_blank');
            <%
                String safeOrderId = order.getOrderId().replace("'", "\\'").replace("\"", "\\\"").replace("\n", " ").replace("\r", " ");
                String safeOrderDate = orderDate.replace("'", "\\'").replace("\"", "\\\"").replace("\n", " ").replace("\r", " ");
                String safeCustomerName = customerName.replace("'", "\\'").replace("\"", "\\\"").replace("\n", " ").replace("\r", " ");
                String safeEmail = (order.getEmail() != null ? order.getEmail() : "N/A").replace("'", "\\'").replace("\"", "\\\"").replace("\n", " ").replace("\r", " ");
                String safePhone = (order.getPhone() != null ? order.getPhone() : "N/A").replace("'", "\\'").replace("\"", "\\\"").replace("\n", " ").replace("\r", " ");
                String safeAddress = (order.getAddress() != null ? order.getAddress() : "N/A").replace("'", "\\'").replace("\"", "\\\"").replace("\n", " ").replace("\r", " ");
                String safeCity = (order.getCity() != null ? order.getCity() : "N/A").replace("'", "\\'").replace("\"", "\\\"").replace("\n", " ").replace("\r", " ");
                String safeTotalAmount = totalAmount.replace("'", "\\'").replace("\"", "\\\"").replace("\n", " ").replace("\r", " ");
            %>
            const orderData = {
                orderId: '<%= safeOrderId %>',
                orderDate: '<%= safeOrderDate %>',
                customerName: '<%= safeCustomerName %>',
                email: '<%= safeEmail %>',
                phone: '<%= safePhone %>',
                address: '<%= safeAddress %>',
                city: '<%= safeCity %>',
                totalAmount: '<%= safeTotalAmount %>',
                stores: [
                    <% if (!storeInfoMap.isEmpty()) { int si = 0; for (Map.Entry<Integer, Map<String, String>> se : storeInfoMap.entrySet()) {
                        Map<String, String> st = se.getValue();
                        String sn = (st.get("storeName") != null ? st.get("storeName") : "N/A").replace("'", "\\'").replace("\"", "\\\"").replace("\n", " ").replace("\r", " ");
                        String sa = (st.get("storeAddress") != null ? st.get("storeAddress") : "N/A").replace("'", "\\'").replace("\"", "\\\"").replace("\n", " ").replace("\r", " ");
                        String sc = (st.get("storeCity") != null ? st.get("storeCity") : "N/A").replace("'", "\\'").replace("\"", "\\\"").replace("\n", " ").replace("\r", " ");
                        String sco = (st.get("contact") != null ? st.get("contact") : "N/A").replace("'", "\\'").replace("\"", "\\\"").replace("\n", " ").replace("\r", " ");
                        String sem = (st.get("email") != null ? st.get("email") : "N/A").replace("'", "\\'").replace("\"", "\\\"").replace("\n", " ").replace("\r", " ");
                    %>{ name: '<%= sn %>', address: '<%= sa %>', city: '<%= sc %>', contact: '<%= sco %>', email: '<%= sem %>' }<%= si < storeInfoMap.size() - 1 ? "," : "" %>
                    <% si++; } } %>
                ],
                items: [
                    <% for (int i = 0; i < allOrderItems.size(); i++) {
                        OrderItem it = allOrderItems.get(i);
                        String iname = (it.getProductName() != null ? it.getProductName() : "Item").replace("'", "\\'").replace("\"", "\\\"").replace("\n", " ").replace("\r", " ");
                    %>{ name: '<%= iname %>', quantity: <%= it.getQuantity() %>, unitPrice: <%= it.getUnitPrice() %>, totalPrice: <%= it.getTotalPrice() %> }<%= i < allOrderItems.size() - 1 ? "," : "" %>
                    <% } %>
                ]
            };

            let receiptHTML = '<!DOCTYPE html><html><head><meta charset="UTF-8"><title>Receipt - Order ' + orderData.orderId + '</title><style>';
            receiptHTML += '* { margin: 0; padding: 0; box-sizing: border-box; }';
            receiptHTML += 'body { font-family: Arial, sans-serif; padding: 40px; max-width: 800px; margin: 0 auto; background: white; color: #000; }';
            receiptHTML += '.receipt-header { text-align: center; margin-bottom: 30px; padding-bottom: 20px; border-bottom: 3px solid #8b7dd8; }';
            receiptHTML += '.receipt-header h1 { color: #8b7dd8; font-size: 2rem; margin-bottom: 10px; }';
            receiptHTML += '.receipt-section { margin-bottom: 25px; }';
            receiptHTML += '.receipt-section h2 { color: #8b7dd8; font-size: 1.2rem; margin-bottom: 15px; padding-bottom: 8px; border-bottom: 2px solid #e0e0e0; }';
            receiptHTML += '.receipt-row { display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid #f0f0f0; }';
            receiptHTML += '.receipt-label { font-weight: 600; color: #333; }';
            receiptHTML += '.receipt-value { color: #666; text-align: right; }';
            receiptHTML += '.receipt-item { padding: 12px; background: #f9f9f9; border-left: 3px solid #8b7dd8; margin-bottom: 10px; border-radius: 4px; }';
            receiptHTML += '.receipt-total { margin-top: 20px; padding-top: 15px; border-top: 2px solid #8b7dd8; font-size: 1.2rem; font-weight: 700; color: #8b7dd8; }';
            receiptHTML += '.receipt-footer { margin-top: 40px; padding-top: 20px; border-top: 2px solid #e0e0e0; text-align: center; color: #666; font-size: 0.9rem; }';
            receiptHTML += '</style></head><body>';
            receiptHTML += '<div class="receipt-header"><h1>Daily Fixer</h1><p>Order Receipt</p></div>';
            receiptHTML += '<div class="receipt-section"><h2>Order Information</h2>';
            receiptHTML += '<div class="receipt-row"><span class="receipt-label">Order ID:</span><span class="receipt-value">' + orderData.orderId + '</span></div>';
            receiptHTML += '<div class="receipt-row"><span class="receipt-label">Order Date:</span><span class="receipt-value">' + orderData.orderDate + '</span></div>';
            receiptHTML += '<div class="receipt-row"><span class="receipt-label">Payment Status:</span><span class="receipt-value" style="color: #27ae60; font-weight: 600;">PAID</span></div></div>';
            receiptHTML += '<div class="receipt-section"><h2>Customer Information</h2>';
            receiptHTML += '<div class="receipt-row"><span class="receipt-label">Name:</span><span class="receipt-value">' + orderData.customerName + '</span></div>';
            receiptHTML += '<div class="receipt-row"><span class="receipt-label">Email:</span><span class="receipt-value">' + orderData.email + '</span></div>';
            receiptHTML += '<div class="receipt-row"><span class="receipt-label">Phone:</span><span class="receipt-value">' + orderData.phone + '</span></div></div>';
            receiptHTML += '<div class="receipt-section"><h2>Delivery Information</h2>';
            receiptHTML += '<div class="receipt-row"><span class="receipt-label">Address:</span><span class="receipt-value">' + orderData.address + '</span></div>';
            receiptHTML += '<div class="receipt-row"><span class="receipt-label">City:</span><span class="receipt-value">' + orderData.city + '</span></div></div>';
            if (orderData.stores && orderData.stores.length > 0) {
                receiptHTML += '<div class="receipt-section"><h2>Store Information</h2>';
                for (let i = 0; i < orderData.stores.length; i++) {
                    const store = orderData.stores[i];
                    if (orderData.stores.length > 1) receiptHTML += '<div style="margin-bottom: 15px;"><div style="font-weight: 600; color: #8b7dd8; margin-bottom: 8px;">Store ' + (i + 1) + '</div>';
                    receiptHTML += '<div class="receipt-row"><span class="receipt-label">Store Name:</span><span class="receipt-value">' + store.name + '</span></div>';
                    receiptHTML += '<div class="receipt-row"><span class="receipt-label">Store Address:</span><span class="receipt-value">' + store.address + '</span></div>';
                    receiptHTML += '<div class="receipt-row"><span class="receipt-label">Store City:</span><span class="receipt-value">' + store.city + '</span></div>';
                    receiptHTML += '<div class="receipt-row"><span class="receipt-label">Contact:</span><span class="receipt-value">' + store.contact + '</span></div>';
                    receiptHTML += '<div class="receipt-row"><span class="receipt-label">Email:</span><span class="receipt-value">' + store.email + '</span></div>';
                    if (orderData.stores.length > 1 && i < orderData.stores.length - 1) receiptHTML += '</div>';
                }
                receiptHTML += '</div>';
            }
            receiptHTML += '<div class="receipt-section"><h2>Order Summary</h2><div class="receipt-items">';
            for (let i = 0; i < orderData.items.length; i++) {
                const item = orderData.items[i];
                receiptHTML += '<div class="receipt-item"><div style="font-weight: 600; margin-bottom: 5px;">' + item.name + '</div>';
                receiptHTML += '<div style="font-size: 0.9em; color: #666;">Quantity: ' + item.quantity + ' × LKR ' + item.unitPrice.toFixed(2) + ' = LKR ' + item.totalPrice.toFixed(2) + '</div></div>';
            }
            receiptHTML += '</div><div class="receipt-total receipt-row"><span class="receipt-label">Total Amount:</span><span class="receipt-value">' + orderData.totalAmount + '</span></div></div>';
            receiptHTML += '<div class="receipt-footer"><p>Thank you for your purchase!</p><p>Daily Fixer - Fix, Learn, Restore</p><p>This is a computer-generated receipt.</p></div>';
            receiptHTML += '</body></html>';

            printWindow.document.write(receiptHTML);
            printWindow.document.close();
            setTimeout(function() { printWindow.print(); }, 250);
        }
    </script>
</body>
</html>
