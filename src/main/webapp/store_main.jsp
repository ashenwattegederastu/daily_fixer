<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daily Fixer - Store</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/store_main.css">


</head>
<body>
<jsp:include page="fragment_cart.jsp"/>

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

<!-- Search Section -->
<div class="container">
    <section class="search-section">
        <h3 class="search-title">What are you looking for?</h3>
        <div class="search-box">
            <input type="text" placeholder="Search for a part/item">
            <button>
                <img src="${pageContext.request.contextPath}/assets/images/search.png" alt="Search">
            </button>
        </div>

        <!-- Category Section -->
        <section class="category-section">
            <h4 class="category-header">Browse Items by Category</h4>
            <div class="category-grid">
                <a href="${pageContext.request.contextPath}/products?category=Cutting Tools" class="category-item">
                    <img src="${pageContext.request.contextPath}/assets/images/saw-machine.png" alt="Cutting Tools">
                    <p class="category-label">Cutting Tools</p>
                </a>

                <a href="${pageContext.request.contextPath}/products?category=Painting Tools" class="category-item">
                    <img src="${pageContext.request.contextPath}/assets/images/paint-roller.png" alt="Painting Tools">
                    <p class="category-label">Painting Tools</p>
                </a>

                <a href="${pageContext.request.contextPath}/products?category=Tool Storage & Safety Gear" class="category-item">
                    <img src="${pageContext.request.contextPath}/assets/images/safety-gear.png" alt="Tool Storage & Safety Gear">
                    <p class="category-label">Tool Storage <br>& Safety Gear</p>
                </a>

                <a href="${pageContext.request.contextPath}/products?category=Electrical Tools & Accessories" class="category-item">
                    <img src="${pageContext.request.contextPath}/assets/images/power-cable.png" alt="Electrical Tools & Accessories">
                    <p class="category-label">Electrical Tools <br>& Accessories</p>
                </a>

                <a href="${pageContext.request.contextPath}/products?category=Power Tools" class="category-item">
                    <img src="${pageContext.request.contextPath}/assets/images/power-drill.png" alt="Power Tools">
                    <p class="category-label">Power Tools</p>
                </a>

                <a href="${pageContext.request.contextPath}/products?category=Cleaning & Maintenance" class="category-item">
                    <img src="${pageContext.request.contextPath}/assets/images/cleaning.png" alt="Cleaning & Maintenance">
                    <p class="category-label">Cleaning & Maintenance</p>
                </a>

                <a href="${pageContext.request.contextPath}/products?category=Vehicle Parts & Accessories" class="category-item">
                    <img src="${pageContext.request.contextPath}/assets/images/tyre.png" alt="Vehicle Parts & Accessories">
                    <p class="category-label">Vehicle Parts <br>& Accessories</p>
                </a>

                <a href="${pageContext.request.contextPath}/products?category=Measuring & Marking Tools" class="category-item">
                    <img src="${pageContext.request.contextPath}/assets/images/tape-measure.png" alt="Measuring & Marking Tools">
                    <p class="category-label">Measuring & <br>Marking Tools</p>
                </a>

                <a href="${pageContext.request.contextPath}/products?category=Tapes" class="category-item">
                    <img src="${pageContext.request.contextPath}/assets/images/masking-tape.png" alt="Tapes">
                    <p class="category-label">Tapes</p>
                </a>

                <a href="${pageContext.request.contextPath}/products?category=Fasteners & Fittings" class="category-item">
                    <img src="${pageContext.request.contextPath}/assets/images/tools.png" alt="Fasteners & Fittings">
                    <p class="category-label">Fasteners & <br>Fittings</p>
                </a>

                <a href="${pageContext.request.contextPath}/products?category=Plumbing Tools & Supplies" class="category-item">
                    <img src="${pageContext.request.contextPath}/assets/images/pipe.png" alt="Plumbing Tools & Supplies">
                    <p class="category-label">Plumbing Tools <br>& Supplies</p>
                </a>

                <a href="${pageContext.request.contextPath}/products?category=Adhesives & Sealants" class="category-item">
                    <img src="${pageContext.request.contextPath}/assets/images/glue.png" alt="Adhesives & Sealants">
                    <p class="category-label">Adhesives & <br>Sealants</p>
                </a>
            </div>
        </section>
    </section>
</div>

<!-- Suggested Products Section -->
<section class="suggested-section">
    <div class="suggested-card">
        <h4 class="suggested-header">You Might Also Like</h4>
        <div class="suggested-grid">
            <a href="${pageContext.request.contextPath}/product_details.jsp" class="suggested-item">
                <img src="${pageContext.request.contextPath}/assets/images/glass_cutter.jpg" alt="Glass Cutter">
                <p class="item-name">Glass Cutter</p>
                <p class="item-desc">Durable tool for precise glass cutting at home or DIY projects.</p>
                <p class="item-price">Rs 1,200</p>
            </a>
            <a href="${pageContext.request.contextPath}/product_details.jsp" class="suggested-item">
                <img src="${pageContext.request.contextPath}/assets/images/sawmachine.jpg" alt="Saw Machine">
                <p class="item-name">Saw Machine</p>
                <p class="item-desc">Efficient cutting tool for wood, metal, and plastic surfaces.</p>
                <p class="item-price">Rs 7,250</p>
            </a>
            <a href="${pageContext.request.contextPath}/product_details.jsp" class="suggested-item">
                <img src="${pageContext.request.contextPath}/assets/images/drill.jpg" alt="Drill Machine">
                <p class="item-name">Drill Machine</p>
                <p class="item-desc">Compact drill for versatile DIY and home repair tasks.</p>
                <p class="item-price">Rs 4,500</p>
            </a>
            <a href="${pageContext.request.contextPath}/product_details.jsp" class="suggested-item">
                <img src="${pageContext.request.contextPath}/assets/images/roller.jpg" alt="Paint Roller">
                <p class="item-name">Paint Roller</p>
                <p class="item-desc">Smooth finish roller for walls, ceilings, and furniture.</p>
                <p class="item-price">Rs 1,200</p>
            </a>
        </div>
    </div>
</section>

</body>
</html>
