<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daily Fixer - Fix, Learn, Restore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/product_details.css">
</head>
    <body>
    <!-- Navigation -->
    <nav id="navbar">
        <div class="nav-container">
            <div class="logo">Daily Fixer</div>
            <ul class="nav-links">
                <li><a href="${pageContext.request.contextPath}/diagnostic.jsp">Diagnostic Tool</a></li>
                <li><a href="${pageContext.request.contextPath}/listguides.jsp">View Repair Guides</a></li>
                <li><a href="${pageContext.request.contextPath}/findtech.jsp">Book a Technician</a></li>
                <li><a href="${pageContext.request.contextPath}/store_main.jsp">Store</a></li>
            </ul>
            <div class="nav-buttons">
                <button class="btn-login">Login</button>
                <button class="btn-signup">Sign Up</button>
            </div>
        </div>
    </nav>
    <div class="floating-cart">
  <a href="#">
    <img src="${pageContext.request.contextPath}/assets/images/shopping-cart.png" alt="Cart">
    <span class="cart-count">1</span>
  </a>
</div>

<!-- Side Cart -->
<div class="side-cart" id="sideCart">
  <div class="cart-header">
    <h2>Shopping Cart</h2>
    <span class="close-cart" id="closeCart">&times;</span>
  </div>
  
  <div class="cart-items">
    <!-- Example cart item -->
    <div class="cart-item">
      <img src="${pageContext.request.contextPath}/assets/images/glass_cutter.jpg" alt="Glass Cutter">
      <div class="item-details">
        <p class="item-name">Glass Cutter</p>
        <p class="item-qty">Qty: 1</p>
        <p class="item-price">Rs 1,200.00</p>
      </div>
      <img src="${pageContext.request.contextPath}/assets/images/dustbin.png" alt="Remove" class="remove-item" title="Remove">
    </div>
  </div>
  
  <div class="cart-footer">
    <p class="subtotal">Subtotal: Rs 3,974.00</p>
    <button class="checkout-btn">Proceed to Checkout</button>
  </div>
</div>


     <div class="product-container">
    
    <!-- Left Section: Image Gallery -->
    <div class="image-section">
      <div class="main-image">
        <img src="${pageContext.request.contextPath}/assets/images/glass_cutter.jpg" alt="Product">
      </div>
      <div class="thumbnail-row">
        <img src="${pageContext.request.contextPath}/assets/images/cutterA.jpg" alt="thumb" class="active">
        <img src="${pageContext.request.contextPath}/assets/images/cutterB.jpg" alt="thumb">
      </div>
    </div>

    <!-- Right Section: Product Info -->
    <div class="details-section">
      <p class="stock">In Stock</p>
      <h1 class="title">Glass CutterL</h1>
      <h2 class="price">Rs 3,974.00</h2>
      

      <div class="quantity-control">
        <button class="qty-btn">-</button>
        <span class="qty">1</span>
        <button class="qty-btn">+</button>
      </div>
      

      <div class="buttons">
        <button class="add-to-cart">Add to Cart</button>
        <button class="buy-now">Buy Now</button>
      </div>

      <div class="product-description">
        <h3>Product Description</h3>
        <p>
          A durable glass cutter designed for precise, clean cuts on glass and mirrors. Perfect for home repairs and DIY projects.
        </p>
      </div>
    </div>

  </div>
<script>
  const floatingCart = document.querySelector('.floating-cart a');
  const sideCart = document.getElementById('sideCart');
  const closeCart = document.getElementById('closeCart');

  // Open side cart
  floatingCart.addEventListener('click', (e) => {
    e.preventDefault();
    sideCart.classList.add('open');
  });

  // Close side cart
  closeCart.addEventListener('click', () => {
    sideCart.classList.remove('open');
  });

  const buyNowBtn = document.querySelector('.buy-now');

  buyNowBtn.addEventListener('click', () => {
    window.location.href = '${pageContext.request.contextPath}/checkout.jsp'; // redirect to checkout page
  });

  const checkoutBtn = document.querySelector('.checkout-btn');

checkoutBtn.addEventListener('click', () => {
  window.location.href = 'checkout.html'; // redirect to checkout page
});

</script>

</script>
</body>
</html>