<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page session="true" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Daily Fixer - Diagnostic Trees</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&family=Inter:wght@400;500;600;700&family=Lora:wght@400;500;600;700&family=IBM+Plex+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/framework.css">
    <style>
        .diagnostic-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 100px 2rem 2rem;
        }
        
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .page-title {
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary);
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
            text-decoration: none;
            color: var(--foreground);
            transition: all 0.2s;
        }
        
        .back-btn:hover {
            background: var(--accent);
        }
        
        .trees-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 20px;
        }
        
        .tree-card {
            background: var(--card);
            border: 2px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 25px;
            transition: all 0.3s ease;
        }
        
        .tree-card:hover {
            border-color: var(--primary);
            box-shadow: var(--shadow-lg);
        }
        
        .tree-card h3 {
            font-size: 1.2rem;
            color: var(--foreground);
            margin-bottom: 10px;
        }
        
        .tree-meta {
            font-size: 0.85rem;
            color: var(--muted-foreground);
            margin-bottom: 10px;
        }
        
        .tree-description {
            font-size: 0.9rem;
            color: var(--muted-foreground);
            margin-bottom: 15px;
            line-height: 1.5;
        }
        
        .tree-rating {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 15px;
        }
        
        .stars {
            color: #f59e0b;
            font-size: 1.1rem;
        }
        
        .rating-text {
            font-size: 0.85rem;
            color: var(--muted-foreground);
        }
        
        .tree-actions {
            display: flex;
            gap: 10px;
        }
        
        .start-btn {
            flex: 1;
            padding: 12px 20px;
            background: var(--primary);
            color: var(--primary-foreground);
            border: none;
            border-radius: var(--radius-md);
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            text-align: center;
            text-decoration: none;
        }
        
        .start-btn:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: var(--muted-foreground);
        }
        
        .empty-state h3 {
            font-size: 1.3rem;
            margin-bottom: 10px;
            color: var(--foreground);
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
    <div class="page-header">
        <h1 class="page-title" id="page-title">Diagnostic Trees</h1>
        <a href="${pageContext.request.contextPath}/diagnostic_categories.jsp" class="back-btn">← Back to Categories</a>
    </div>
    
    <div id="trees-container" class="trees-grid">
        <div class="loading">Loading diagnostic trees...</div>
    </div>
</main>

<script>
    const contextPath = '${pageContext.request.contextPath}';
    
    document.addEventListener('DOMContentLoaded', function() {
        const urlParams = new URLSearchParams(window.location.search);
        const subcategoryId = urlParams.get('subcategoryId');
        const subcategoryName = urlParams.get('name');
        
        if (subcategoryName) {
            document.getElementById('page-title').textContent = subcategoryName + ' - Diagnostic Trees';
        }
        
        if (subcategoryId) {
            loadTrees(subcategoryId);
        } else {
            document.getElementById('trees-container').innerHTML = 
                '<div class="empty-state"><h3>Invalid subcategory</h3><p>Please select a valid subcategory.</p></div>';
        }
    });
    
    async function loadTrees(subcategoryId) {
        try {
            const response = await fetch(contextPath + '/api/tree?subcategoryId=' + subcategoryId);
            const data = await response.json();
            
            if (data.success) {
                renderTrees(data.trees);
            } else {
                document.getElementById('trees-container').innerHTML = 
                    '<div class="empty-state"><h3>Error</h3><p>Error loading trees</p></div>';
            }
        } catch (error) {
            console.error('Error:', error);
            document.getElementById('trees-container').innerHTML = 
                '<div class="empty-state"><h3>Error</h3><p>Error loading trees</p></div>';
        }
    }
    
    function renderTrees(trees) {
        const container = document.getElementById('trees-container');
        
        if (trees.length === 0) {
            container.innerHTML = 
                '<div class="empty-state">' +
                    '<h3>No Diagnostic Trees Available</h3>' +
                    '<p>There are no diagnostic trees available for this category yet.</p>' +
                '</div>';
            return;
        }
        
        container.innerHTML = trees.map(tree => 
            '<div class="tree-card">' +
                '<h3>' + escapeHtml(tree.treeName) + '</h3>' +
                '<div class="tree-meta">' +
                    'By: <strong>' + escapeHtml(tree.creatorUsername) + '</strong>' +
                '</div>' +
                '<p class="tree-description">' + (escapeHtml(tree.description) || 'No description available') + '</p>' +
                '<div class="tree-rating">' +
                    '<span class="stars">' + '★'.repeat(Math.round(tree.avgRating)) + '☆'.repeat(5 - Math.round(tree.avgRating)) + '</span>' +
                    '<span class="rating-text">' + tree.avgRating.toFixed(1) + ' (' + tree.ratingCount + ' ratings)</span>' +
                '</div>' +
                '<div class="tree-actions">' +
                    '<a href="' + contextPath + '/diagnostic_runner.jsp?treeId=' + tree.treeId + '" class="start-btn">' +
                        'Start Diagnostic' +
                    '</a>' +
                '</div>' +
            '</div>'
        ).join('');
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
