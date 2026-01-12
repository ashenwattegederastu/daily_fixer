<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page session="true" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Daily Fixer - Diagnostic Categories</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&family=Inter:wght@400;500;600;700&family=Lora:wght@400;500;600;700&family=IBM+Plex+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/framework.css">
    <style>
        .diagnostic-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 100px 2rem 2rem;
        }
        
        .page-title {
            font-size: 2.2rem;
            font-weight: 700;
            margin-bottom: 1rem;
            color: var(--primary);
            text-align: center;
        }
        
        .page-subtitle {
            text-align: center;
            color: var(--muted-foreground);
            margin-bottom: 2.5rem;
        }
        
        .category-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 2rem;
        }
        
        .category-card {
            background: var(--card);
            border: 2px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 25px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-align: center;
        }
        
        .category-card:hover {
            border-color: var(--primary);
            transform: translateY(-4px);
            box-shadow: var(--shadow-lg);
        }
        
        .category-card h3 {
            font-size: 1.3rem;
            color: var(--foreground);
            margin-bottom: 10px;
        }
        
        .category-card p {
            color: var(--muted-foreground);
            font-size: 0.9rem;
        }
        
        .category-icon {
            font-size: 3rem;
            margin-bottom: 15px;
        }
        
        /* Subcategory Section */
        .subcategory-section {
            display: none;
        }
        
        .subcategory-section.active {
            display: block;
        }
        
        .back-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
            background: var(--secondary);
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            cursor: pointer;
            font-weight: 500;
            margin-bottom: 20px;
            transition: all 0.2s;
        }
        
        .back-btn:hover {
            background: var(--accent);
        }
        
        .subcategory-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 15px;
        }
        
        .subcategory-card {
            background: var(--card);
            border: 2px solid var(--border);
            border-radius: var(--radius-md);
            padding: 20px;
            cursor: pointer;
            transition: all 0.2s ease;
            text-align: center;
        }
        
        .subcategory-card:hover {
            border-color: var(--primary);
            background: var(--accent);
        }
        
        .subcategory-card h4 {
            color: var(--foreground);
            font-size: 1rem;
            margin: 0;
        }
        
        .loading {
            text-align: center;
            padding: 40px;
            color: var(--muted-foreground);
        }
    </style>
</head>
<body>

<!-- Include Header -->
<jsp:include page="/pages/shared/header.jsp" />

<main class="diagnostic-container">
    <!-- Categories Section -->
    <div id="categories-section">
        <h1 class="page-title">Diagnostic Tool</h1>
        <p class="page-subtitle">Select a category to diagnose your issue</p>
        
        <div id="category-grid" class="category-grid">
            <div class="loading">Loading categories...</div>
        </div>
    </div>
    
    <!-- Subcategories Section -->
    <div id="subcategories-section" class="subcategory-section">
        <button class="back-btn" onclick="showCategories()">← Back to Categories</button>
        <h2 class="page-title" id="selected-category-name"></h2>
        <p class="page-subtitle">Select a subcategory</p>
        
        <div id="subcategory-grid" class="subcategory-grid">
            <div class="loading">Loading subcategories...</div>
        </div>
    </div>
</main>

<script>
    const contextPath = '${pageContext.request.contextPath}';
    
    // Category icons mapping
    const categoryIcons = {
        'Home Repair': '🏠',
        'Home Electronic Repair': '🔌',
        'Vehicle Repair': '🚗'
    };
    
    // Category descriptions
    const categoryDescriptions = {
        'Home Repair': 'Plumbing, Electrical, Carpentry, Roofing, and more',
        'Home Electronic Repair': 'Mobile Devices, Computers, Appliances, and more',
        'Vehicle Repair': 'Engine, Brakes, Suspension, Transmission, and more'
    };
    
    document.addEventListener('DOMContentLoaded', function() {
        loadCategories();
    });
    
    async function loadCategories() {
        try {
            const response = await fetch(contextPath + '/api/category');
            const data = await response.json();
            
            if (data.success) {
                renderCategories(data.categories);
            } else {
                document.getElementById('category-grid').innerHTML = 
                    '<p class="loading">Error loading categories</p>';
            }
        } catch (error) {
            console.error('Error:', error);
            document.getElementById('category-grid').innerHTML = 
                '<p class="loading">Error loading categories</p>';
        }
    }
    
    function renderCategories(categories) {
        const container = document.getElementById('category-grid');
        
        container.innerHTML = categories.map(cat => 
            '<div class="category-card" onclick="selectCategory(' + cat.categoryId + ', \'' + escapeHtml(cat.name) + '\')">' +
                '<div class="category-icon">' + (categoryIcons[cat.name] || '📋') + '</div>' +
                '<h3>' + escapeHtml(cat.name) + '</h3>' +
                '<p>' + (categoryDescriptions[cat.name] || 'Various diagnostic trees available') + '</p>' +
            '</div>'
        ).join('');
    }
    
    async function selectCategory(categoryId, categoryName) {
        document.getElementById('categories-section').style.display = 'none';
        document.getElementById('subcategories-section').classList.add('active');
        document.getElementById('selected-category-name').textContent = categoryName;
        document.getElementById('subcategory-grid').innerHTML = '<div class="loading">Loading subcategories...</div>';
        
        try {
            const response = await fetch(contextPath + '/api/category/subcategories/' + categoryId);
            const data = await response.json();
            
            if (data.success) {
                renderSubcategories(data.subcategories);
            } else {
                document.getElementById('subcategory-grid').innerHTML = 
                    '<p class="loading">Error loading subcategories</p>';
            }
        } catch (error) {
            console.error('Error:', error);
            document.getElementById('subcategory-grid').innerHTML = 
                '<p class="loading">Error loading subcategories</p>';
        }
    }
    
    function renderSubcategories(subcategories) {
        const container = document.getElementById('subcategory-grid');
        
        if (subcategories.length === 0) {
            container.innerHTML = '<p class="loading">No subcategories available</p>';
            return;
        }
        
        container.innerHTML = subcategories.map(sub => 
            '<div class="subcategory-card" onclick="goToTrees(' + sub.subcategoryId + ', \'' + escapeHtml(sub.name) + '\')">' +
                '<h4>' + escapeHtml(sub.name) + '</h4>' +
            '</div>'
        ).join('');
    }
    
    function showCategories() {
        document.getElementById('categories-section').style.display = 'block';
        document.getElementById('subcategories-section').classList.remove('active');
    }
    
    function goToTrees(subcategoryId, subcategoryName) {
        window.location.href = contextPath + '/diagnostic_trees.jsp?subcategoryId=' + subcategoryId + 
            '&name=' + encodeURIComponent(subcategoryName);
    }
    
    function escapeHtml(text) {
        if (!text) return '';
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }
</script>

</body>
</html>
