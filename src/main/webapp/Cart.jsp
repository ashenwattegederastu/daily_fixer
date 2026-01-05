<%@ page import="java.util.Map" %>
<%@ page import="com.dailyfixer.model.CartItem" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Daily Fixer - Cart</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/cart.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f6fa;
            color: #2d2d3d;
            margin: 0;
            padding: 0;
        }

        .cart-container {
            max-width: 950px;
            margin: 120px auto 50px auto;
            background: #fff;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.08);
        }

        h2 {
            text-align: center;
            margin-bottom: 30px;
            color: #7b2cff;
        }

        .cart-items {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .cart-item {
            display: flex;
            gap: 20px;
            align-items: center;
            padding: 15px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .cart-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        .cart-item img {
            width: 90px;
            height: 90px;
            object-fit: cover;
            border-radius: 10px;
            border: 2px solid #e0d6ff;
        }

        .item-details {
            flex: 1;
        }

        .item-name {
            font-weight: 700;
            font-size: 1.1rem;
            margin-bottom: 6px;
            color: #360062;
        }

        .item-qty, .item-price {
            color: #555;
            font-size: 0.95rem;
            margin-bottom: 4px;
        }

        .remove-item {
            cursor: pointer;
            background: #ff4d4f;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 8px;
            font-weight: 600;
            transition: background 0.3s, transform 0.2s;
        }

        .remove-item:hover {
            background: #d9363e;
            transform: translateY(-2px);
        }

        .subtotal {
            font-weight: 700;
            margin-top: 30px;
            font-size: 1.4em;
            text-align: right;
            color: #7b2cff;
        }

        .empty-cart-msg {
            text-align: center;
            font-size: 1.2rem;
            color: #888;
            margin-top: 30px;
        }

        /* Checkout Button */
        .checkout-btn {
            display: block;
            margin: 30px auto 0 auto;
            padding: 12px 25px;
            background: linear-gradient(135deg, #7b2cff, #8b95ff);
            color: white;
            font-weight: 700;
            font-size: 1rem;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .checkout-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(139,125,216,0.3);
        }

        /* Responsive */
        @media (max-width: 700px) {
            .cart-item {
                flex-direction: column;
                align-items: flex-start;
            }

            .cart-item img {
                width: 100%;
                height: auto;
            }

            .subtotal {
                text-align: left;
            }
        }

    </style>
</head>
<body>

<jsp:include page="fragment_cart.jsp"/>

<div class="cart-container">
    <h2>Your Cart</h2>

    <%
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
    %>
    <p class="empty-cart-msg">Your cart is empty.</p>
    <p class="subtotal">Subtotal: Rs 0</p>
    <%
    } else {
    %>
    <div class="cart-items">
        <%
            for (CartItem ci : cart.values()) {
        %>
        <div class="cart-item" data-id="<%=ci.getProductId()%>">
            <img src="data:image/jpeg;base64,<%=ci.getImageBase64()%>" alt="<%=ci.getName()%>">
            <div class="item-details">
                <p class="item-name"><%=ci.getName()%></p>
                <p class="item-qty">Quantity: <%=ci.getQuantity()%></p>
                <p class="item-price">Price: Rs <%=ci.getPrice()%></p>
            </div>
            <button class="remove-item" data-product-id="<%=ci.getProductId()%>">Remove</button>
        </div>
        <% } %>
    </div>

    <p class="subtotal">
        Subtotal: Rs
        <span id="subtotal">
                <%
                    int subtotal = 0;
                    for (CartItem ci : cart.values()) {
                        subtotal += ci.getQuantity() * ci.getPrice();
                    }
                    out.print(subtotal);
                %>
            </span>
    </p>

    <form id="checkoutForm">
        <button type="button" id="checkoutBtn">Proceed to Checkout</button>
    </form>

    <% } %>
</div>

<script>
    function updateSubtotal() {
        const items = document.querySelectorAll(".cart-item");
        let subtotal = 0;
        items.forEach(item => {
            const qtyText = item.querySelector(".item-qty").innerText;
            const priceText = item.querySelector(".item-price").innerText;
            const qty = parseInt(qtyText.replace("Quantity: ", ""));
            const price = parseInt(priceText.replace("Price: Rs ", ""));
            subtotal += qty * price;
        });
        document.getElementById("subtotal").innerText = subtotal || 0; // 0 if empty
    }

    document.querySelectorAll(".remove-item").forEach(btn => {
        btn.addEventListener("click", () => {
            const productId = btn.dataset.productId;
            fetch('<%=request.getContextPath()%>/removeFromCart', {
                method: "POST",
                headers: {"Content-Type": "application/x-www-form-urlencoded"},
                body: "productId=" + productId
            })
                .then(res => res.json())
                .then(data => {
                    if(data.error) {
                        alert(data.error);
                        return;
                    }
                    // Remove item from DOM
                    const itemDiv = btn.closest(".cart-item");
                    itemDiv.remove();

                    // Update floating cart count
                    const cartCountEl = document.querySelector(".cart-count");
                    if(cartCountEl) cartCountEl.innerText = data.cartCount;

                    // Update subtotal
                    updateSubtotal();

                    // Show "cart empty" if no items
                    if(document.querySelectorAll(".cart-item").length === 0){
                        document.querySelector(".cart-items")?.remove();
                        document.querySelector(".subtotal").innerHTML = "Subtotal: Rs 0";
                        const cartContainer = document.querySelector(".cart-container");
                        const emptyMsg = document.createElement("p");
                        emptyMsg.className = "empty-cart-msg";
                        emptyMsg.innerText = "Your cart is empty.";
                        cartContainer.insertBefore(emptyMsg, document.querySelector(".subtotal"));
                    }
                })
                .catch(() => alert("Server error"));
        });
    });
    document.getElementById("checkoutBtn").addEventListener("click", () => {
        // Just redirect to checkout.jsp
        window.location.href = "checkout.jsp";
    });

</script>

</body>
</html>
