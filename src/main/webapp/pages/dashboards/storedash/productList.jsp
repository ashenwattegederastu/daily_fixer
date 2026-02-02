<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.dailyfixer.model.User" %>
<%@ page import="com.dailyfixer.model.Product" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("currentUser");
    if (user == null || !"store".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Product> products = (List<Product>) request.getAttribute("products");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Product Catalogue | Daily Fixer</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

<style>
:root {
    --panel-color: #dcdaff;
    --accent: #8b95ff;
    --text-dark: #000000;
    --text-secondary: #333333;
    --shadow-sm: 0 4px 12px rgba(0,0,0,0.12);
    --shadow-md: 0 8px 24px rgba(0,0,0,0.18);
    --shadow-lg: 0 12px 36px rgba(0,0,0,0.22);
}

/* Reset */
* { margin:0; padding:0; box-sizing:border-box; }
body {
    font-family: 'Inter', sans-serif;
    background-color: #ffffff;
    color: var(--text-dark);
    display: flex;
    min-height: 100vh;
}

/* Top Navbar */
.topbar {
    position: fixed;
    top:0; left:0; right:0;
    height:76px;
    background-color: var(--panel-color);
    border-bottom: 1px solid rgba(0,0,0,0.1);
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0 30px;
    z-index: 200;
    box-shadow: var(--shadow-md);
}
.topbar .logo { font-size: 1.5em; font-weight: 700; color: var(--accent); }
.topbar .panel-name { font-weight: 600; flex:1; text-align:center; color: var(--text-dark); }
.topbar .logout-btn {
    padding: 0.6rem 1.2rem;
    background: linear-gradient(135deg, var(--accent), #7ba3d4);
    border: none;
    color: #fff;
    border-radius: 8px;
    cursor: pointer;
    font-weight: 600;
    font-size: 0.9rem;
    box-shadow: var(--shadow-sm);
    text-decoration: none;
}
.topbar .logout-btn:hover {
    transform: translateY(-2px);
    box-shadow: var(--shadow-md);
    opacity: 0.9;
}

/* Sidebar */
.sidebar {
    width: 240px;
    background-color: var(--panel-color);
    height: 100vh;
    position: fixed;
    top:0;
    left:0;
    padding-top: 96px;
    box-shadow: var(--shadow-md);
    overflow-y: auto;
    z-index: 100;
}
.sidebar h3 { padding: 0 20px 12px; font-size: 0.85em; color: var(--text-dark); text-transform: uppercase; }
.sidebar ul { list-style:none; }
.sidebar a {
    display:block;
    padding:12px 20px;
    text-decoration:none;
    color: var(--text-dark);
    font-weight:500;
    border-left:3px solid transparent;
    border-radius:0 8px 8px 0;
    margin-bottom:4px;
    transition: all 0.2s;
}
.sidebar a:hover, .sidebar a.active {
    background-color: #f0f0ff;
    border-left-color: var(--accent);
}

/* Main Content */
.container {
    flex:1;
    margin-left:240px;
    margin-top:83px;
    padding:30px;
}
.container h2 {
    font-size:1.6em;
    margin-bottom:20px;
    color: #000000;
}

/* Top Bar */
.top-bar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
}
.btn-add {
    background: var(--accent);
    color: white;
    padding: 10px 20px;
    border-radius: 8px;
    text-decoration: none;
    font-weight: 600;
    box-shadow: var(--shadow-sm);
}
.btn-add:hover {
    transform: translateY(-2px);
    box-shadow: var(--shadow-md);
    opacity: 0.9;
}

/* Table Styles */
table {
    width:100%;
    border-collapse: collapse;
    box-shadow: var(--shadow-sm);
    background: white;
    border-radius: 12px;
    overflow: hidden;
    border: 1px solid rgba(0,0,0,0.1);
}
thead { background-color: var(--panel-color); }
th, td {
    padding:12px 10px;
    text-align:left;
    border-bottom:1px solid #ddd;
}
tbody tr:hover { background-color:#f9f9f9; }

img.service-thumb {
    width: 100px;
    height: 80px;
    border-radius: 8px;
    object-fit: cover;
}

/* Buttons */
.btn { 
    padding:6px 12px; 
    border:none; 
    border-radius:8px; 
    cursor:pointer; 
    font-weight:500; 
    margin-right:5px;
    font-size: 0.85em;
    text-decoration: none;
    display: inline-block;
}
.edit-btn { background: var(--accent); color:#fff; }
.delete-btn { background: #e74c3c; color:#fff; }

.btn:hover {
    opacity: 0.9;
    transform: translateY(-1px);
}

/* Confirmation Modal */
.confirm-modal {
    display: none;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0,0,0,0.6);
    justify-content: center;
    align-items: center;
    z-index: 500;
}

.confirm-modal .modal-content {
    background: white;
    padding: 30px;
    border-radius: 12px;
    max-width: 400px;
    width: 90%;
    text-align: center;
    box-shadow: var(--shadow-lg);
}

.confirm-modal h3 {
    color: var(--accent);
    margin-bottom: 15px;
}

.confirm-modal p {
    color: var(--text-secondary);
    margin-bottom: 25px;
}

.confirm-modal .modal-buttons {
    display: flex;
    gap: 15px;
    justify-content: center;
}

.confirm-modal .modal-btn {
    padding: 10px 20px;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    font-weight: 500;
}

.confirm-modal .confirm-btn {
    background: #e74c3c;
    color: white;
}

.confirm-modal .cancel-btn {
    background: #ddd;
    color: var(--text-dark);
}

.close-btn {
    position: absolute;
    top: 15px;
    right: 20px;
    font-size: 1.5em;
    font-weight: bold;
    cursor: pointer;
    color: var(--text-secondary);
}
</style>
</head>
<body>

<header class="topbar">
    <div class="logo">Daily Fixer</div>
    <div class="panel-name">Store Panel</div>
    <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Log Out</a>
</header>

<aside class="sidebar">
    <h3>Navigation</h3>
    <ul>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/storedashmain.jsp">Dashboard</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/orders.jsp">Orders</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/upfordelivery.jsp">Up for Delivery</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/completedorders.jsp">Completed Orders</a></li>
        <li><a href="${pageContext.request.contextPath}/ListProductsServlet" class="active">Catalogue</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/myProfile.jsp">Profile</a></li>
    </ul>
</aside>

<main class="container">
    <!-- Top Bar -->
    <div class="top-bar">
        <h2>Product Catalogue</h2>
        <a class="btn-add" href="${pageContext.request.contextPath}/pages/dashboards/storedash/addProduct.jsp">+ Add Product</a>
    </div>

    <!-- Products Table -->
    <table>
        <thead>
            <tr>
                <th>Image</th>
                <th>Name</th>
                <th>Type</th>
                <th>Quantity</th>
                <th>Description</th>
                <th>Price</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <% if(products != null && !products.isEmpty()){
                for(Product p : products){ %>
            <tr>
                <td>
                    <% if(p.getImage() != null){ %>
                    <img class="service-thumb" src="data:image/jpeg;base64,<%=java.util.Base64.getEncoder().encodeToString(p.getImage())%>">
                    <% } else { %>
                    <img class="service-thumb" src="${pageContext.request.contextPath}/assets/images/tools.png" alt="No Image">
                    <% } %>
                </td>
                <td><%=p.getName()%></td>
                <td><%=p.getType()%></td>
                <td><%=p.getQuantity()%> <%=p.getQuantityUnit()%></td>
                <td><%=p.getDescription()%></td>
                <td>Rs. <%=p.getPrice()%></td>
                <td>
                    <a href="${pageContext.request.contextPath}/pages/dashboards/storedash/editProduct.jsp?productId=<%=p.getProductId()%>" class="btn edit-btn">Edit</a>
                    <button class="btn delete-btn" onclick="confirmDelete('<%=p.getProductId()%>', '<%=p.getName()%>')">Delete</button>
                </td>
            </tr>
            <% }} else { %>
            <tr><td colspan="6" style="text-align:center; color:#777;">No products found.</td></tr>
            <% } %>
        </tbody>
    </table>
</main>

<!-- Confirmation Modal -->
<div id="confirmModal" class="confirm-modal">
    <div class="modal-content">
        <span class="close-btn" onclick="closeConfirmModal()">&times;</span>
        <h3>Confirm Delete</h3>
        <p>Are you sure you want to delete the product "<span id="productName"></span>"?</p>
        <p style="color: #e74c3c; font-size: 0.9em;">This action cannot be undone.</p>
        
        <div class="modal-buttons">
            <button class="modal-btn confirm-btn" onclick="deleteProduct()">Yes, Delete</button>
            <button class="modal-btn cancel-btn" onclick="closeConfirmModal()">Cancel</button>
        </div>
    </div>
</div>

<script>
let productToDelete = '';

function confirmDelete(productId, productName) {
    productToDelete = productId;
    document.getElementById('productName').textContent = productName;
    document.getElementById('confirmModal').style.display = 'flex';
}

function closeConfirmModal() {
    document.getElementById('confirmModal').style.display = 'none';
    productToDelete = '';
}

function deleteProduct() {
    if (productToDelete) {
        window.location.href = '${pageContext.request.contextPath}/DeleteProductServlet?productId=' + productToDelete;
    }
}

// Close modal on outside click
document.getElementById('confirmModal').addEventListener('click', e => {
    if(e.target.id === 'confirmModal') {
        closeConfirmModal();
    }
});
</script>

</body>
</html>
