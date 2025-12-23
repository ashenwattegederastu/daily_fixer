<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daily Fixer - Fix, Learn, Restore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/checkout.css">
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
    
    
 <div class="page-title">
        <h1>Checkout</h1>
    </div>
<div class="checkout-container">
   

  <!-- Left: Shipping Address -->
  <div class="shipping">
    <h2>Shipping Address</h2>
    <form id="shippingForm">
      <label for="name">Name</label>
      <input type="text" id="name" placeholder="Name">

      <label for="phone">Phone Number</label>
      <input type="text" id="phone" placeholder="Phone Number">

      <div class="address-row">
        <div>
          <label for="province">Province</label>
          <select id="province">
            <option>Select Province</option>
          </select>
        </div>
        <div>
          <label for="district">District</label>
          <select id="district">
            <option>Select District</option>
          </select>
        </div>
        <div>
          <label for="city">City</label>
          <select id="city">
            <option>Select City</option>
          </select>
        </div>
      </div>

      <label for="address">Address</label>
      <textarea id="address" placeholder="Address"></textarea>

    </form>
  </div>

  

  <!-- Right: Order Summary -->
  <div class="order-summary">
    <h2>Order Summary</h2>
    <div class="cart-item">
      <img src="${pageContext.request.contextPath}/assets/images/glass_cutter.jpg" alt="Product">
      <div class="item-details">
        <p class="item-name">Glass Cutter</p>
        <p class="item-qty">Qty: 1</p>
        <p class="item-price">Rs 1,200.00</p>
      </div>
    </div>

    <div class="totals">
      <div>Subtotal <span>Rs 1,200.00</span></div>
      <div>Discount <span>Rs 0.00</span></div>
      <div>Shipping <span>Rs 0.00</span></div>
      <div class="total">Total <span>Rs 1,200.00</span></div>
    </div>


    <button class="place-order">Proceed to Pay</button>
  </div>
</div>

</body>
</html>