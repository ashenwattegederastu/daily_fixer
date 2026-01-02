<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.dailyfixer.model.Guide" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    List<Guide> guides = (List<Guide>) request.getAttribute("guides");
    String keyword = (String) request.getAttribute("keyword");
    String mainCategory = (String) request.getAttribute("mainCategory");
    String subCategory = (String) request.getAttribute("subCategory");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Repair Guides | Daily Fixer</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/framework.css">
    <style>
        .page-container {
            max-width: 1200px;
            margin: 100px auto 3rem;
            padding: 1rem 2rem;
        }
        .page-title {
            font-size: 2.5rem;
            text-align: center;
            margin-bottom: 2rem;
            color: var(--primary);
        }
        .search-filter-container {
            background: var(--card);
            padding: 1.5rem;
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-sm);
            margin-bottom: 2rem;
            border: 1px solid var(--border);
        }
        .search-filter-form {
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
            align-items: flex-end;
        }
        .form-group {
            flex: 1;
            min-width: 200px;
        }
        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: var(--foreground);
        }
        .form-group input,
        .form-group select {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 2px solid var(--border);
            border-radius: var(--radius-md);
            font-size: 0.95rem;
            background-color: var(--input);
            color: var(--foreground);
            font-family: inherit;
        }
        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: var(--primary);
        }
        .search-btn {
            padding: 0.75rem 1.5rem;
            background: var(--primary);
            color: var(--primary-foreground);
            border: none;
            border-radius: var(--radius-md);
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .search-btn:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }
        .clear-btn {
            padding: 0.75rem 1.5rem;
            background: var(--secondary);
            color: var(--secondary-foreground);
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            cursor: pointer;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
        }
        .clear-btn:hover {
            background: var(--accent);
        }
        .guides-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 1.5rem;
        }
        .guide-card {
            background: var(--card);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-sm);
            overflow: hidden;
            transition: all 0.3s ease;
            border: 1px solid var(--border);
        }
        .guide-card:hover {
            transform: translateY(-6px);
            box-shadow: var(--shadow-lg);
        }
        .guide-card img {
            width: 100%;
            height: 180px;
            object-fit: cover;
        }
        .guide-content {
            padding: 1.2rem;
        }
        .guide-content h3 {
            margin-bottom: 0.5rem;
            color: var(--foreground);
            font-size: 1.1rem;
        }
        .guide-meta {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
            margin-bottom: 0.75rem;
        }
        .category-tag {
            font-size: 0.75rem;
            padding: 0.25rem 0.5rem;
            background: var(--accent);
            color: var(--accent-foreground);
            border-radius: var(--radius-sm);
        }
        .guide-content p {
            color: var(--muted-foreground);
            font-size: 0.9rem;
            margin-bottom: 1rem;
        }
        .view-btn {
            display: inline-block;
            padding: 0.5rem 1.2rem;
            background: var(--primary);
            color: var(--primary-foreground);
            text-decoration: none;
            border-radius: var(--radius-md);
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .view-btn:hover {
            box-shadow: var(--shadow-md);
            transform: translateY(-2px);
        }
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: var(--muted-foreground);
        }
        .empty-state h3 {
            font-size: 1.5rem;
            margin-bottom: 1rem;
            color: var(--foreground);
        }
    </style>
</head>
<body>
<jsp:include page="/pages/shared/header.jsp" />

<div class="page-container">
    <h1 class="page-title">Repair Guides</h1>
    
    <div class="search-filter-container">
        <form action="${pageContext.request.contextPath}/ViewGuidesServlet" method="get" class="search-filter-form">
            <div class="form-group">
                <label for="keyword">Search</label>
                <input type="text" id="keyword" name="keyword" placeholder="Search guides..." 
                       value="<%= keyword != null ? keyword : "" %>">
            </div>
            <div class="form-group">
                <label for="mainCategory">Main Category</label>
                <select id="mainCategory" name="mainCategory" onchange="updateSubCategories()">
                    <option value="">All Categories</option>
                    <option value="Home Repair" <%= "Home Repair".equals(mainCategory) ? "selected" : "" %>>🏠 Home Repair</option>
                    <option value="Home Electronics" <%= "Home Electronics".equals(mainCategory) ? "selected" : "" %>>🔌 Home Electronics / Appliance</option>
                    <option value="Vehicle Repair" <%= "Vehicle Repair".equals(mainCategory) ? "selected" : "" %>>🚗 Vehicle Repair</option>
                </select>
            </div>
            <div class="form-group">
                <label for="subCategory">Subcategory</label>
                <select id="subCategory" name="subCategory">
                    <option value="">All Subcategories</option>
                </select>
            </div>
            <button type="submit" class="search-btn">Search</button>
            <a href="${pageContext.request.contextPath}/ViewGuidesServlet" class="clear-btn">Clear</a>
        </form>
    </div>

    <% if (guides != null && !guides.isEmpty()) { %>
    <div class="guides-grid">
        <% for (Guide g : guides) { %>
        <div class="guide-card">
            <img src="${pageContext.request.contextPath}/ImageServlet?id=<%= g.getGuideId() %>" 
                 alt="<%= g.getTitle() %>"
                 onerror="this.src='${pageContext.request.contextPath}/assets/images/placeholder.jpg'">
            <div class="guide-content">
                <h3><%= g.getTitle() %></h3>
                <div class="guide-meta">
                    <span class="category-tag"><%= g.getMainCategory() %></span>
                    <span class="category-tag"><%= g.getSubCategory() %></span>
                </div>
                <p>By <%= g.getCreatorName() != null ? g.getCreatorName() : "Unknown" %></p>
                <a href="${pageContext.request.contextPath}/ViewGuideServlet?id=<%= g.getGuideId() %>" class="view-btn">View Guide</a>
            </div>
        </div>
        <% } %>
    </div>
    <% } else { %>
    <div class="empty-state">
        <h3>No guides found</h3>
        <p>Try adjusting your search or filter criteria</p>
    </div>
    <% } %>
</div>

<script>
const subCategories = {
    'Home Repair': ['Plumbing', 'Electrical', 'Masonry', 'Painting & Finishing', 'Carpentry', 'Roofing', 
                    'Flooring & Tiling', 'Doors & Windows', 'Ceiling & False Ceiling', 'Waterproofing', 
                    'Glass & Mirrors', 'Locks & Hardware'],
    'Home Electronics': ['Refrigerator', 'Washing Machine', 'Microwave Oven', 'Electric Kettle', 'Rice Cooker',
                         'Mixer / Blender', 'Air Conditioner', 'Water Heater', 'Fans', 'Television',
                         'Home Theatre / Speakers', 'Inverter / UPS', 'Voltage Stabilizer'],
    'Vehicle Repair': ['Engine System', 'Fuel System', 'Electrical System', 'Battery & Charging', 'Transmission',
                       'Clutch System', 'Brake System', 'Steering System', 'Suspension System', 'Tyres & Wheels',
                       'Cooling System', 'Exhaust System', 'Body & Interior']
};

function updateSubCategories() {
    const mainCat = document.getElementById('mainCategory').value;
    const subCatSelect = document.getElementById('subCategory');
    const currentSubCat = '<%= subCategory != null ? subCategory : "" %>';
    
    subCatSelect.innerHTML = '<option value="">All Subcategories</option>';
    
    if (mainCat && subCategories[mainCat]) {
        subCategories[mainCat].forEach(sub => {
            const option = document.createElement('option');
            option.value = sub;
            option.textContent = sub;
            if (sub === currentSubCat) {
                option.selected = true;
            }
            subCatSelect.appendChild(option);
        });
    }
}

// Initialize subcategories on page load
document.addEventListener('DOMContentLoaded', updateSubCategories);
</script>
<script src="${pageContext.request.contextPath}/assets/js/dark-mode.js"></script>
</body>
</html>
