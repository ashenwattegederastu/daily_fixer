<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page session="true" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Daily Fixer - Diagnostic</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&family=Inter:wght@400;500;600;700&family=Lora:wght@400;500;600;700&family=IBM+Plex+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/framework.css">
    <style>
        .diagnostic-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 100px 2rem 2rem;
            min-height: 100vh;
        }
        
        .diagnostic-card {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 40px;
            box-shadow: var(--shadow-lg);
            text-align: center;
        }
        
        .tree-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary);
            margin-bottom: 10px;
        }
        
        .tree-meta {
            font-size: 0.9rem;
            color: var(--muted-foreground);
            margin-bottom: 30px;
        }
        
        .question-text {
            font-size: 1.4rem;
            font-weight: 600;
            color: var(--foreground);
            margin-bottom: 30px;
            line-height: 1.4;
        }
        
        .result-text {
            font-size: 1.3rem;
            font-weight: 500;
            color: var(--foreground);
            margin-bottom: 20px;
            line-height: 1.5;
            padding: 20px;
            background: #ffb3b3;
            border-radius: var(--radius-md);
        }
        
        .result-badge {
            display: inline-block;
            background: var(--destructive);
            color: var(--destructive-foreground);
            padding: 5px 15px;
            border-radius: var(--radius-md);
            font-size: 0.85rem;
            font-weight: 600;
            margin-bottom: 20px;
        }
        
        .options-container {
            display: flex;
            flex-direction: column;
            gap: 12px;
            margin-bottom: 30px;
        }
        
        .option-btn {
            padding: 15px 25px;
            background: var(--secondary);
            border: 2px solid var(--border);
            border-radius: var(--radius-md);
            font-size: 1rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s ease;
            color: var(--foreground);
        }
        
        .option-btn:hover {
            border-color: var(--primary);
            background: var(--accent);
            transform: translateX(5px);
        }
        
        .nav-buttons {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-top: 20px;
        }
        
        .back-btn {
            padding: 12px 25px;
            background: var(--secondary);
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
            text-decoration: none;
            color: var(--foreground);
        }
        
        .back-btn:hover {
            background: var(--accent);
        }
        
        .restart-btn {
            padding: 12px 25px;
            background: var(--primary);
            color: var(--primary-foreground);
            border: none;
            border-radius: var(--radius-md);
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
        }
        
        .restart-btn:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }
        
        /* Rating Section */
        .rating-section {
            margin-top: 30px;
            padding-top: 30px;
            border-top: 1px solid var(--border);
        }
        
        .rating-section h4 {
            margin-bottom: 15px;
            color: var(--foreground);
        }
        
        .star-rating {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-bottom: 15px;
        }
        
        .star-rating button {
            font-size: 2rem;
            background: none;
            border: none;
            cursor: pointer;
            color: #ddd;
            transition: all 0.2s;
        }
        
        .star-rating button:hover,
        .star-rating button.active {
            color: #f59e0b;
            transform: scale(1.1);
        }
        
        .rating-message {
            font-size: 0.9rem;
            color: var(--muted-foreground);
        }
        
        /* Progress Indicator */
        .progress-indicator {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            margin-bottom: 30px;
        }
        
        .progress-step {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background: var(--secondary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.8rem;
            font-weight: 600;
            color: var(--muted-foreground);
        }
        
        .progress-step.current {
            background: var(--primary);
            color: var(--primary-foreground);
        }
        
        .progress-step.completed {
            background: oklch(0.6290 0.1902 156.4499);
            color: white;
        }
        
        .progress-line {
            width: 30px;
            height: 2px;
            background: var(--border);
        }
        
        .loading {
            text-align: center;
            padding: 40px;
            color: var(--muted-foreground);
        }
        
        .error-state {
            text-align: center;
            padding: 40px;
            color: var(--destructive);
        }
    </style>
</head>
<body>

<!-- Include Header -->
<jsp:include page="/pages/shared/header.jsp" />

<main class="diagnostic-container">
    <div id="diagnostic-card" class="diagnostic-card">
        <div class="loading">Loading diagnostic...</div>
    </div>
</main>

<script>
    const contextPath = '${pageContext.request.contextPath}';
    const isLoggedIn = ${sessionScope.currentUser != null};
    
    let treeData = null;
    let currentNode = null;
    let history = [];
    
    document.addEventListener('DOMContentLoaded', function() {
        const urlParams = new URLSearchParams(window.location.search);
        const treeId = urlParams.get('treeId');
        
        if (treeId) {
            loadTree(treeId);
        } else {
            showError('No tree ID provided');
        }
    });
    
    async function loadTree(treeId) {
        try {
            const response = await fetch(contextPath + '/api/tree/' + treeId);
            const data = await response.json();
            
            if (data.success) {
                treeData = data.tree;
                currentNode = data.rootNode;
                history = [];
                
                if (currentNode) {
                    renderCurrentNode();
                } else {
                    showError('This diagnostic tree has no content yet.');
                }
            } else {
                showError(data.error || 'Error loading tree');
            }
        } catch (error) {
            console.error('Error:', error);
            showError('Error loading diagnostic tree');
        }
    }
    
    function renderCurrentNode() {
        const container = document.getElementById('diagnostic-card');
        
        const isResult = currentNode.nodeType === 'RESULT';
        const stepNumber = history.length + 1;
        
        let progressHtml = '';
        if (history.length > 0) {
            progressHtml = '<div class="progress-indicator">';
            for (let i = 0; i < history.length; i++) {
                progressHtml += `<div class="progress-step completed">${i + 1}</div>`;
                progressHtml += '<div class="progress-line"></div>';
            }
            progressHtml += `<div class="progress-step current">${stepNumber}</div>`;
            progressHtml += '</div>';
        }
        
        let optionsHtml = '';
        if (!isResult && currentNode.children && currentNode.children.length > 0) {
            optionsHtml = '<div class="options-container">';
            for (const child of currentNode.children) {
                optionsHtml += `
                    <button class="option-btn" onclick="selectOption(${child.nodeId})">
                        ${escapeHtml(child.optionLabel || 'Continue')}
                    </button>
                `;
            }
            optionsHtml += '</div>';
        }
        
        let ratingHtml = '';
        if (isResult && isLoggedIn) {
            ratingHtml = `
                <div class="rating-section">
                    <h4>Rate this diagnostic</h4>
                    <div class="star-rating">
                        <button onclick="submitRating(1)">★</button>
                        <button onclick="submitRating(2)">★</button>
                        <button onclick="submitRating(3)">★</button>
                        <button onclick="submitRating(4)">★</button>
                        <button onclick="submitRating(5)">★</button>
                    </div>
                    <p class="rating-message" id="rating-message">Click to rate</p>
                </div>
            `;
        } else if (isResult && !isLoggedIn) {
            ratingHtml = `
                <div class="rating-section">
                    <p class="rating-message">
                        <a href="${contextPath}/login.jsp">Log in</a> to rate this diagnostic
                    </p>
                </div>
            `;
        }
        
        container.innerHTML = `
            <h2 class="tree-title">${escapeHtml(treeData.treeName)}</h2>
            <div class="tree-meta">
                ${escapeHtml(treeData.categoryName)} → ${escapeHtml(treeData.subcategoryName)} | 
                By: ${escapeHtml(treeData.creatorUsername)}
            </div>
            
            ${progressHtml}
            
            ${isResult ? `
                <div class="result-badge">Diagnosis Result</div>
                <div class="result-text">${escapeHtml(currentNode.nodeText)}</div>
            ` : `
                <div class="question-text">${escapeHtml(currentNode.nodeText)}</div>
                ${optionsHtml}
            `}
            
            <div class="nav-buttons">
                ${history.length > 0 ? `
                    <button class="back-btn" onclick="goBack()">← Previous</button>
                ` : ''}
                ${isResult ? `
                    <button class="restart-btn" onclick="restart()">Start Over</button>
                ` : ''}
                <a href="${contextPath}/diagnostic_categories.jsp" class="back-btn">Exit</a>
            </div>
            
            ${ratingHtml}
        `;
        
        // Load user's current rating if logged in
        if (isResult && isLoggedIn) {
            loadUserRating();
        }
    }
    
    function selectOption(nodeId) {
        // Find the selected child node
        const selectedChild = currentNode.children.find(child => child.nodeId === nodeId);
        
        if (selectedChild) {
            // Save current node to history
            history.push(currentNode);
            // Move to selected child
            currentNode = selectedChild;
            renderCurrentNode();
        }
    }
    
    function goBack() {
        if (history.length > 0) {
            currentNode = history.pop();
            renderCurrentNode();
        }
    }
    
    function restart() {
        loadTree(treeData.treeId);
    }
    
    async function loadUserRating() {
        try {
            const response = await fetch(contextPath + '/api/rating?treeId=' + treeData.treeId);
            const data = await response.json();
            
            if (data.success && data.rating > 0) {
                updateStarDisplay(data.rating);
                document.getElementById('rating-message').textContent = 'Your rating: ' + data.rating + ' star' + (data.rating > 1 ? 's' : '');
            }
        } catch (error) {
            console.error('Error loading rating:', error);
        }
    }
    
    async function submitRating(rating) {
        try {
            const response = await fetch(contextPath + '/api/rating', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    treeId: treeData.treeId,
                    rating: rating
                })
            });
            
            const data = await response.json();
            
            if (data.success) {
                updateStarDisplay(rating);
                document.getElementById('rating-message').textContent = 
                    'Thank you! Average rating: ' + data.avgRating.toFixed(1) + ' (' + data.ratingCount + ' ratings)';
            } else {
                document.getElementById('rating-message').textContent = 'Error: ' + data.error;
            }
        } catch (error) {
            console.error('Error submitting rating:', error);
            document.getElementById('rating-message').textContent = 'Error submitting rating';
        }
    }
    
    function updateStarDisplay(rating) {
        const buttons = document.querySelectorAll('.star-rating button');
        buttons.forEach((btn, index) => {
            btn.classList.toggle('active', index < rating);
        });
    }
    
    function showError(message) {
        const container = document.getElementById('diagnostic-card');
        container.innerHTML = `
            <div class="error-state">
                <h3>Error</h3>
                <p>${escapeHtml(message)}</p>
                <div class="nav-buttons">
                    <a href="${contextPath}/diagnostic_categories.jsp" class="back-btn">Back to Categories</a>
                </div>
            </div>
        `;
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
