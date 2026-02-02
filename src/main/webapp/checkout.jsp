<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.dailyfixer.model.CartItem" %>
<%@ page import="com.dailyfixer.dao.ProductDAO" %>
<%@ page import="com.dailyfixer.model.Product" %>

<%
    // Get cart from session
    Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");

    // Prepare items to checkout (cart or direct Buy Now)
    Map<Integer, CartItem> itemsToCheckout = new HashMap<>();

    if (cart != null && !cart.isEmpty()) {
        itemsToCheckout.putAll(cart);
    } else {
        String productIdParam = request.getParameter("productId");
        String quantityParam = request.getParameter("quantity");

        if (productIdParam != null && quantityParam != null && !productIdParam.isEmpty()) {
            int productId = Integer.parseInt(productIdParam);
            int quantity = Integer.parseInt(quantityParam);

            ProductDAO dao = new ProductDAO();
            Product product = dao.getProductById(productId);
            if (product != null) {
                CartItem item = new CartItem(
                        product.getProductId(),
                        product.getName(),
                        product.getPrice(),
                        quantity,
                        product.getImageBase64()
                );
                itemsToCheckout.put(productId, item);
            }
        }
    }

    // If no items, show message and return
    if (itemsToCheckout.isEmpty()) {
%>
<p>No products to checkout.</p>
<a href="store_main.jsp">Back to Store</a>
<%
        return;
    }

    // Store cart items in session for post-payment order processing
    session.setAttribute("itemsToCheckout", itemsToCheckout);

    double total = 0; // Initialize total for order summary
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Checkout - Daily Fixer</title>
    <link rel="stylesheet" href="assets/css/checkout.css">
</head>
<body>

<nav>
    <div class="nav-container">
        <div class="logo">Daily Fixer</div>
        <ul class="nav-links">
            <li><a href="diagnostic.jsp">Diagnostic Tool</a></li>
            <li><a href="listguides.jsp">Repair Guides</a></li>
            <li><a href="findtech.jsp">Technicians</a></li>
            <li><a href="store_main.jsp">Store</a></li>
        </ul>
    </div>
</nav>


<!-- Entire form wraps shipping + order summary -->
<form method="post" action="redirectToPayment">

    <div class="checkout-container">
        <!-- Left: Shipping Details -->
        <div class="shipping">
            <h2>Shipping Details</h2>
            <label>Name</label><input type="text" name="name" required>
            <label>Address</label><input type="text" name="address" required>
            <label>Phone</label><input type="text" name="phone" required>
            <div class="address-row">
                <div>
                    <label>Province</label>
                    <select name="province"><option>Select Province</option></select>
                </div>
                <div>
                    <label>District</label>
                    <select name="district"><option>Select District</option></select>
                </div>
                <div>
                    <label>City</label>
                    <select name="city"><option>Select City</option></select>
                </div>
            </div>
        </div>

        <!-- Right: Order Summary -->
        <div class="order-summary">
            <h2>Order Summary</h2>

            <% for(CartItem item : itemsToCheckout.values()) {
                double subtotal = item.getQuantity() * item.getPrice();
                total += subtotal;
            %>
            <div class="checkout-item">
                <img src="data:image/jpeg;base64,<%=item.getImageBase64()%>" alt="<%=item.getName()%>" width="100">
                <div class="item-details">
                    <p><strong><%=item.getName()%></strong></p>
                    <p>Qty: <%=item.getQuantity()%></p>
                    <p>Price: Rs <%=String.format("%.2f", item.getPrice()) %></p>
                    <p>Subtotal: Rs <%=String.format("%.2f", subtotal) %></p>
                </div>
            </div>
            <% } %>

            <div class="totals">
                <div>Subtotal <span>Rs <%=String.format("%.2f", total)%></span></div>
                <div>Discount <span>Rs 0.00</span></div>
                <div>Shipping <span>Rs 0.00</span></div>
                <div class="total">Total <span>Rs <%=String.format("%.2f", total)%></span></div>
            </div>

            <!-- Place Order button -->
            <button type="submit" class="place-order">Place Order</button>
        </div>
    </div>
</form>

</body>
</html>
