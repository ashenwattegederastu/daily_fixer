<%@ page import="com.dailyfixer.dao.ProductDAO" %>
<%@ page import="com.dailyfixer.model.Product" %>

<%
    String productIdParam = request.getParameter("productId");
    Product product = null;

    if (productIdParam != null && !productIdParam.isEmpty()) {
        int productId = Integer.parseInt(productIdParam);
        ProductDAO dao = new ProductDAO();
        product = dao.getProductById(productId);
    }

    if (product == null) {
%>
<p>Product not found</p>
<a href="store_main.jsp">Back</a>
<%
        return;
    }

    boolean outOfStock = product.getQuantity() <= 0;
%>



<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title><%= product.getName() %></title>
    <link rel="stylesheet" href="assets/css/product_details.css">
</head>
<body>

<!-- Floating Cart -->
<jsp:include page="fragment_cart.jsp"/>

<!-- Navbar -->
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

<!-- Product Container -->
<div class="product-container">

    <!-- Left Image Section -->
    <div class="image-section">
        <div class="main-image">
            <img src="data:image/jpeg;base64,<%=product.getImageBase64()%>"
                 alt="<%=product.getName()%>">
        </div>
    </div>

    <!-- Right Details Section -->
    <div class="details-section">

        <p class="stock" style="color:<%= outOfStock ? "red" : "green" %>;">
            <%= outOfStock ? "Out of Stock" : "In Stock: " + product.getQuantity() %>
        </p>

        <h1 class="title"><%= product.getName() %></h1>
        <h2 class="price">Rs <%= product.getPrice() %></h2>

        <!-- Quantity + Buttons -->
        <div class="quantity-control">

            <button class="qty-btn" id="minusBtn" <%= outOfStock ? "disabled" : "" %>>-</button>

            <input type="number"
                   id="qty"
                   class="qty"
                   value="1"
                   min="1"
                   max="<%=product.getQuantity()%>"
                <%= outOfStock ? "disabled" : "" %>>

            <button class="qty-btn" id="plusBtn" <%= outOfStock ? "disabled" : "" %>>+</button>
        </div>

        <div class="buttons">
            <button class="add-to-cart"
                    id="addBtn"
                    data-product-id="<%=product.getProductId()%>"
                    <%= outOfStock ? "disabled" : "" %>>
                Add to Cart
            </button>

            <button class="buy-now"
                    id="buyNowBtn"
                    data-product-id="<%=product.getProductId()%>"
                    <%= outOfStock ? "disabled" : "" %>>
                Buy Now
            </button>

        </div>

        <!-- Description -->
        <div class="product-description">
            <h3>Product Description</h3>
            <p><%= product.getDescription() %></p>
        </div>

    </div>
</div>

<script>
    const btn = document.getElementById("addBtn");
    const qty = document.getElementById("qty");
    const minusBtn = document.getElementById("minusBtn");
    const plusBtn = document.getElementById("plusBtn");

    const contextPath = "<%=request.getContextPath()%>";
    const stock = <%= product.getQuantity() %>;

    // Quantity increment/decrement
    if (minusBtn && plusBtn) {
        minusBtn.onclick = () => {
            let v = parseInt(qty.value);
            if (v > 1) qty.value = v - 1;
        };

        plusBtn.onclick = () => {
            let v = parseInt(qty.value);
            if (v < stock) qty.value = v + 1;
        };
    }

    // Add to Cart (do not alter)
    if (btn) {
        btn.addEventListener("click", () => {

            if (stock <= 0) {
                alert("Product is out of stock");
                return;
            }

            const quantity = parseInt(qty.value);
            if (!quantity || quantity < 1) {
                alert("Invalid quantity");
                return;
            }

            const params = new URLSearchParams();
            params.append("productId", btn.dataset.productId);
            params.append("quantity", quantity);

            fetch(contextPath + "/addToCart", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: params.toString()
            })
                .then(res => res.json())
                .then(data => {
                    if (data.error) {
                        alert(data.error);
                        return;
                    }

                    const cartCount = document.querySelector(".cart-count");
                    if (cartCount) cartCount.innerText = data.cartCount;

                    alert("Product added to cart");
                })
                .catch(() => alert("Server error"));
        });
    }

    // Buy Now
    // Buy Now Button
    const buyNowBtn = document.getElementById("buyNowBtn");
    const qtyInput = document.getElementById("qty");

    if (buyNowBtn) {
        buyNowBtn.addEventListener("click", () => {
            const productId = buyNowBtn.getAttribute("data-product-id"); // read attribute
            const quantity = qtyInput ? parseInt(qtyInput.value) : 1;

            // Debug: check values
            console.log("Buy Now clicked - productId:", productId, "quantity:", quantity);

            if (!productId) {
                alert("Product ID missing!");
                return;
            }

            if (!quantity || quantity < 1) {
                alert("Invalid quantity!");
                return;
            }

            // Redirect to checkout.jsp with proper query params
            window.location.href = "checkout.jsp?productId=" + productId + "&quantity=" + quantity;
        });
    }


</script>


</body>
</html>
