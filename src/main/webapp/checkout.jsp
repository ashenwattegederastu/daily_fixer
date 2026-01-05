<%@ page import="java.util.Map" %>
<%@ page import="com.dailyfixer.model.CartItem" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
    if(cart == null || cart.isEmpty()) {
%>
<p>Your cart is empty.</p>
<a href="store_main.jsp">Back to Store</a>
<%
        return;
    }

    double total = 0;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Checkout - Daily Fixer</title>
    <link rel="stylesheet" href="assets/css/checkout.css">
</head>
<body>

<h2>Checkout</h2>

<div class="checkout-container">
    <!-- Left: Shipping Details -->
    <div class="shipping">
        <h2>Shipping Details</h2>
        <form>
            <label>Name</label><input type="text" name="name" required>
            <label>Address</label><input type="text" name="address" required>
            <label>Phone</label><input type="text" name="phone" required>
            <div class="address-row">
                <div>
                    <label>Province</label>
                    <select><option>Select Province</option></select>
                </div>
                <div>
                    <label>District</label>
                    <select><option>Select District</option></select>
                </div>
                <div>
                    <label>City</label>
                    <select><option>Select City</option></select>
                </div>
            </div>
        </form>
    </div>

    <!-- Right: Order Summary -->
    <div class="order-summary">
        <h2>Order Summary</h2>

        <%
            for(CartItem item : cart.values()){
                double subtotal = item.getQuantity() * item.getPrice();
                total += subtotal;
        %>
        <div class="checkout-item">
            <img src="data:image/jpeg;base64,<%=item.getImageBase64()%>" alt="<%=item.getName()%>">
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

        <button class="place-order">Place Order</button>
    </div>
</div>


</body>
</html>
