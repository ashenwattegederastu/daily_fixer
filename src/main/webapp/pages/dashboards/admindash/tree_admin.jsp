<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page import="com.dailyfixer.model.User" %>

<%
    User user = (User) session.getAttribute("currentUser");
    if (user == null || user.getRole() == null ||
            !"admin".equalsIgnoreCase(user.getRole().trim())) {
        response.sendRedirect(request.getContextPath() + "/pages/shared/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Decision Trees | Admin Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&family=Inter:wght@400;500;600;700&family=Lora:wght@400;500;600;700&family=IBM+Plex+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/framework.css">
    <style>
        /* Decision Tree Specific Styles */
        .tree-tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }
        .tree-tab {
            padding: 10px 20px;
            background: var(--secondary);
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            cursor: pointer;
            font-weight: 500;
            transition: all 0.2s;
        }
        .tree-tab:hover, .tree-tab.active {
            background: var(--primary);
            color: var(--primary-foreground);
            border-color: var(--primary);
        }
        
        /* Tree Visualization Container */
        .tree-visualization {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 20px;
            overflow-x: auto;
            min-height: 400px;
        }
        
        /* Tree Node Styles - Flexbox based */
        .tree-container {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        .tree-node-wrapper {
            display: flex;
            flex-direction: column;
            align-items: flex-start;
        }
        .tree-node {
            padding: 15px 20px;
            border-radius: var(--radius-md);
            min-width: 200px;
            max-width: 350px;
            cursor: pointer;
            transition: all 0.2s;
            box-shadow: var(--shadow-sm);
            position: relative;
        }
        .tree-node:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }
        .tree-node.question {
            background-color: #e0e0e0;
            border: 2px solid #bdbdbd;
            color: #333;
        }
        .tree-node.result {
            background-color: #ffb3b3;
            border: 2px solid #ff9999;
            color: #333;
        }
        .tree-node .node-label {
            font-size: 0.75rem;
            color: #666;
            margin-bottom: 4px;
            font-weight: 600;
        }
        .tree-node .node-text {
            font-size: 0.95rem;
            font-weight: 500;
        }
        .tree-node .node-type-badge {
            position: absolute;
            top: 5px;
            right: 5px;
            font-size: 0.65rem;
            padding: 2px 6px;
            border-radius: 3px;
            background: rgba(0,0,0,0.1);
        }
        
        /* Children Container */
        .node-children {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-left: 40px;
            padding-left: 20px;
            border-left: 2px solid var(--border);
            margin-top: 10px;
        }
        
        /* Node Actions */
        .node-actions {
            display: flex;
            gap: 5px;
            margin-top: 8px;
        }
        .node-action-btn {
            padding: 4px 8px;
            font-size: 0.75rem;
            border-radius: 4px;
            border: none;
            cursor: pointer;
            transition: all 0.2s;
        }
        .node-action-btn.add {
            background: var(--primary);
            color: var(--primary-foreground);
        }
        .node-action-btn.edit {
            background: var(--secondary);
            color: var(--secondary-foreground);
        }
        .node-action-btn.delete {
            background: var(--destructive);
            color: var(--destructive-foreground);
        }
        
        /* Modal Dialog Styles */
        dialog {
            border: none;
            border-radius: var(--radius-lg);
            padding: 0;
            max-width: 500px;
            width: 90%;
            box-shadow: var(--shadow-xl);
        }
        dialog::backdrop {
            background: rgba(0,0,0,0.5);
        }
        .dialog-content {
            padding: 25px;
        }
        .dialog-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .dialog-header h3 {
            margin: 0;
            font-size: 1.25rem;
        }
        .dialog-close {
            background: none;
            border: none;
            font-size: 1.5rem;
            cursor: pointer;
            color: var(--muted-foreground);
        }
        .dialog-footer {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
            margin-top: 20px;
        }
        
        /* Tree List Styles */
        .tree-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }
        .tree-card {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 20px;
            transition: all 0.2s;
        }
        .tree-card:hover {
            box-shadow: var(--shadow-md);
        }
        .tree-card h4 {
            margin: 0 0 10px;
            color: var(--foreground);
        }
        .tree-card .meta {
            font-size: 0.85rem;
            color: var(--muted-foreground);
            margin-bottom: 10px;
        }
        .tree-card .rating {
            color: #f59e0b;
            font-weight: 600;
        }
        .tree-card-actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }
        
        /* Category Selection */
        .category-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }
        .category-item {
            padding: 15px;
            background: var(--card);
            border: 2px solid var(--border);
            border-radius: var(--radius-md);
            cursor: pointer;
            text-align: center;
            transition: all 0.2s;
        }
        .category-item:hover, .category-item.selected {
            border-color: var(--primary);
            background: var(--accent);
        }
        
        /* Empty State */
        .empty-tree-state {
            text-align: center;
            padding: 40px;
            color: var(--muted-foreground);
        }
        .empty-tree-state button {
            margin-top: 15px;
        }
    </style>
</head>

<body>

<header class="topbar">
    <div class="logo">Daily Fixer</div>
    <div class="panel-name">Decision Tree Management</div>
    <div style="display: flex; align-items: center; gap: 10px;">
        <button id="theme-toggle-btn" class="theme-toggle" onclick="toggleTheme()" aria-label="Toggle dark mode">🌙 Dark</button>
        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Log Out</a>
    </div>
</header>

<aside class="sidebar">
    <h3>Navigation</h3>
    <ul>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/admindash/admindashmain.jsp"> Dashboard</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/users"> User Management</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/admindash/tree_admin.jsp" class="active"> Decision Trees</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/admindash/flags.jsp"> Flags</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/admindash/transactions.jsp"> Transactions</a></li>
    </ul>
</aside>

<main class="main-content">
    <div class="dashboard-header">
        <h1>Decision Trees</h1>
        <p>Manage diagnostic decision trees for users</p>
    </div>

    <!-- Tabs -->
    <div class="tree-tabs">
        <button class="tree-tab active" onclick="showTab('my-trees')">My Trees</button>
        <button class="tree-tab" onclick="showTab('all-trees')">All Trees</button>
        <button class="tree-tab" onclick="showTab('create-tree')">Create New Tree</button>
        <button class="tree-tab" onclick="showTab('manage-categories')">Manage Categories</button>
    </div>

    <!-- My Trees Section -->
    <div id="my-trees-section" class="section">
        <h2>My Decision Trees</h2>
        <div id="my-trees-list" class="tree-list">
            <!-- Dynamically populated -->
        </div>
    </div>

    <!-- All Trees Section -->
    <div id="all-trees-section" class="section" style="display:none;">
        <h2>All Decision Trees</h2>
        <div id="all-trees-list" class="tree-list">
            <!-- Dynamically populated -->
        </div>
    </div>

    <!-- Create Tree Section -->
    <div id="create-tree-section" class="section" style="display:none;">
        <h2>Create New Decision Tree</h2>
        <div class="form-container">
            <div class="form-group">
                <label>Select Category</label>
                <div id="category-selection" class="category-grid">
                    <!-- Dynamically populated -->
                </div>
            </div>
            <div class="form-group" id="subcategory-group" style="display:none;">
                <label>Select Subcategory</label>
                <div id="subcategory-selection" class="category-grid">
                    <!-- Dynamically populated -->
                </div>
            </div>
            <div id="tree-form-fields" style="display:none;">
                <div class="form-group">
                    <label for="tree-name">Tree Name</label>
                    <input type="text" id="tree-name" class="form-input" placeholder="Enter tree name">
                </div>
                <div class="form-group">
                    <label for="tree-description">Description</label>
                    <textarea id="tree-description" class="form-input" rows="3" placeholder="Enter description"></textarea>
                </div>
                <div class="form-actions">
                    <button class="btn-primary" onclick="createTree()">Create Tree</button>
                    <button class="btn-secondary" onclick="resetTreeForm()">Reset</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Manage Categories Section -->
    <div id="manage-categories-section" class="section" style="display:none;">
        <h2>Manage Categories</h2>
        <div class="form-container">
            <h3>Add New Category</h3>
            <div class="form-group">
                <label for="new-category-name">Category Name</label>
                <input type="text" id="new-category-name" class="form-input" placeholder="Enter category name">
            </div>
            <button class="btn-primary" onclick="addCategory()">Add Category</button>
            
            <hr style="margin: 30px 0; border-color: var(--border);">
            
            <h3>Add New Subcategory</h3>
            <div class="form-group">
                <label for="parent-category">Parent Category</label>
                <select id="parent-category" class="filter-select">
                    <option value="">Select Category</option>
                </select>
            </div>
            <div class="form-group">
                <label for="new-subcategory-name">Subcategory Name</label>
                <input type="text" id="new-subcategory-name" class="form-input" placeholder="Enter subcategory name">
            </div>
            <button class="btn-primary" onclick="addSubcategory()">Add Subcategory</button>
        </div>
    </div>

    <!-- Tree Editor Section (hidden by default) -->
    <div id="tree-editor-section" class="section" style="display:none;">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
            <h2 id="editing-tree-name">Editing Tree</h2>
            <button class="btn-secondary" onclick="closeTreeEditor()">← Back to Trees</button>
        </div>
        <div class="tree-visualization">
            <div id="tree-container" class="tree-container">
                <!-- Tree nodes rendered here -->
            </div>
        </div>
    </div>
</main>

<!-- Node Edit Dialog -->
<dialog id="node-dialog">
    <div class="dialog-content">
        <div class="dialog-header">
            <h3 id="dialog-title">Edit Node</h3>
            <button class="dialog-close" onclick="closeNodeDialog()">×</button>
        </div>
        <form id="node-form">
            <input type="hidden" id="node-id">
            <input type="hidden" id="node-tree-id">
            <input type="hidden" id="node-parent-id">
            <div class="form-group">
                <label for="node-option-label">Option Label (Answer text shown on button)</label>
                <input type="text" id="node-option-label" class="form-input" placeholder="e.g., Yes, No, Check Power">
            </div>
            <div class="form-group">
                <label for="node-text">Node Text (Question or Result)</label>
                <textarea id="node-text" class="form-input" rows="3" placeholder="Enter the question or result text"></textarea>
            </div>
            <div class="form-group">
                <label for="node-type">Node Type</label>
                <select id="node-type" class="filter-select">
                    <option value="QUESTION">Question</option>
                    <option value="RESULT">Result (Endpoint)</option>
                </select>
            </div>
            <div class="dialog-footer">
                <button type="button" class="btn-secondary" onclick="closeNodeDialog()">Cancel</button>
                <button type="button" class="btn-primary" onclick="saveNode()">Save</button>
            </div>
        </form>
    </div>
</dialog>

<!-- Delete Confirmation Dialog -->
<dialog id="delete-dialog">
    <div class="dialog-content">
        <div class="dialog-header">
            <h3>Confirm Delete</h3>
            <button class="dialog-close" onclick="closeDeleteDialog()">×</button>
        </div>
        <p id="delete-message">Are you sure you want to delete this item?</p>
        <div class="dialog-footer">
            <button class="btn-secondary" onclick="closeDeleteDialog()">Cancel</button>
            <button class="btn-danger" id="confirm-delete-btn">Delete</button>
        </div>
    </div>
</dialog>

<script src="${pageContext.request.contextPath}/assets/js/dark-mode.js"></script>
<script>
    const contextPath = '${pageContext.request.contextPath}';
    const currentUserId = ${user.getUserId()};
    
    let selectedCategoryId = null;
    let selectedSubcategoryId = null;
    let currentTreeId = null;
    
    // Initialize
    document.addEventListener('DOMContentLoaded', function() {
        loadMyTrees();
        loadCategories();
    });
    
    // Tab Management
    function showTab(tabName) {
        document.querySelectorAll('.section').forEach(s => s.style.display = 'none');
        document.querySelectorAll('.tree-tab').forEach(t => t.classList.remove('active'));
        
        document.getElementById(tabName + '-section').style.display = 'block';
        event.target.classList.add('active');
        
        if (tabName === 'my-trees') {
            loadMyTrees();
        } else if (tabName === 'all-trees') {
            loadAllTrees();
        } else if (tabName === 'create-tree') {
            loadCategoriesForSelection();
        } else if (tabName === 'manage-categories') {
            loadCategoriesForManagement();
        }
    }
    
    // API Helpers
    async function apiGet(endpoint) {
        const response = await fetch(contextPath + endpoint);
        return response.json();
    }
    
    async function apiPost(endpoint, data) {
        const response = await fetch(contextPath + endpoint, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        });
        return response.json();
    }
    
    async function apiPut(endpoint, data) {
        const response = await fetch(contextPath + endpoint, {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        });
        return response.json();
    }
    
    async function apiDelete(endpoint) {
        const response = await fetch(contextPath + endpoint, {
            method: 'DELETE'
        });
        return response.json();
    }
    
    // Load Trees
    async function loadMyTrees() {
        const data = await apiGet('/api/tree?userId=' + currentUserId);
        if (data.success) {
            renderTreeList('my-trees-list', data.trees, true);
        }
    }
    
    async function loadAllTrees() {
        const data = await apiGet('/api/tree');
        if (data.success) {
            renderTreeList('all-trees-list', data.trees, false);
        }
    }
    
    function renderTreeList(containerId, trees, canEdit) {
        const container = document.getElementById(containerId);
        if (trees.length === 0) {
            container.innerHTML = '<div class="empty-tree-state"><p>No decision trees found.</p></div>';
            return;
        }
        
        container.innerHTML = trees.map(tree => 
            '<div class="tree-card">' +
                '<h4>' + escapeHtml(tree.treeName) + '</h4>' +
                '<div class="meta">' +
                    '<strong>By:</strong> ' + escapeHtml(tree.creatorUsername) + '<br>' +
                    '<strong>Category:</strong> ' + escapeHtml(tree.categoryName) + ' → ' + escapeHtml(tree.subcategoryName) +
                '</div>' +
                '<div class="rating">' +
                    '★'.repeat(Math.round(tree.avgRating)) + '☆'.repeat(5 - Math.round(tree.avgRating)) +
                    ' (' + tree.avgRating.toFixed(1) + ' - ' + tree.ratingCount + ' ratings)' +
                '</div>' +
                '<p style="margin-top: 10px; font-size: 0.9rem; color: var(--muted-foreground);">' +
                    escapeHtml(tree.description || 'No description') +
                '</p>' +
                '<div class="tree-card-actions">' +
                    (canEdit ? 
                        '<button class="btn-primary" onclick="editTree(' + tree.treeId + ')">Edit Tree</button>' +
                        '<button class="btn-danger" onclick="confirmDeleteTree(' + tree.treeId + ', \'' + escapeHtml(tree.treeName) + '\')">Delete</button>'
                    : 
                        '<button class="btn-secondary" onclick="viewTree(' + tree.treeId + ')">View Tree</button>'
                    ) +
                '</div>' +
            '</div>'
        ).join('');
    }
    
    // Category Management
    async function loadCategories() {
        const data = await apiGet('/api/category');
        return data.categories || [];
    }
    
    async function loadCategoriesForSelection() {
        const categories = await loadCategories();
        const container = document.getElementById('category-selection');
        container.innerHTML = categories.map(cat => 
            '<div class="category-item" onclick="selectCategory(' + cat.categoryId + ', this)">' +
                escapeHtml(cat.name) +
            '</div>'
        ).join('');
        
        document.getElementById('subcategory-group').style.display = 'none';
        document.getElementById('tree-form-fields').style.display = 'none';
        selectedCategoryId = null;
        selectedSubcategoryId = null;
    }
    
    async function loadCategoriesForManagement() {
        const categories = await loadCategories();
        const select = document.getElementById('parent-category');
        select.innerHTML = '<option value="">Select Category</option>' +
            categories.map(cat => '<option value="' + cat.categoryId + '">' + escapeHtml(cat.name) + '</option>').join('');
    }
    
    async function selectCategory(categoryId, element) {
        document.querySelectorAll('#category-selection .category-item').forEach(el => el.classList.remove('selected'));
        element.classList.add('selected');
        selectedCategoryId = categoryId;
        
        const data = await apiGet('/api/category/subcategories/' + categoryId);
        if (data.success) {
            const container = document.getElementById('subcategory-selection');
            container.innerHTML = data.subcategories.map(sub => 
                '<div class="category-item" onclick="selectSubcategory(' + sub.subcategoryId + ', this)">' +
                    escapeHtml(sub.name) +
                '</div>'
            ).join('');
            document.getElementById('subcategory-group').style.display = 'block';
        }
    }
    
    function selectSubcategory(subcategoryId, element) {
        document.querySelectorAll('#subcategory-selection .category-item').forEach(el => el.classList.remove('selected'));
        element.classList.add('selected');
        selectedSubcategoryId = subcategoryId;
        document.getElementById('tree-form-fields').style.display = 'block';
    }
    
    async function addCategory() {
        const name = document.getElementById('new-category-name').value.trim();
        if (!name) {
            alert('Please enter a category name');
            return;
        }
        
        const data = await apiPost('/api/category', { type: 'category', name: name });
        if (data.success) {
            alert('Category added successfully');
            document.getElementById('new-category-name').value = '';
            loadCategoriesForManagement();
        } else {
            alert('Error: ' + data.error);
        }
    }
    
    async function addSubcategory() {
        const categoryId = document.getElementById('parent-category').value;
        const name = document.getElementById('new-subcategory-name').value.trim();
        
        if (!categoryId || !name) {
            alert('Please select a category and enter a subcategory name');
            return;
        }
        
        const data = await apiPost('/api/category', { type: 'subcategory', categoryId: parseInt(categoryId), name: name });
        if (data.success) {
            alert('Subcategory added successfully');
            document.getElementById('new-subcategory-name').value = '';
        } else {
            alert('Error: ' + data.error);
        }
    }
    
    // Tree CRUD
    async function createTree() {
        const treeName = document.getElementById('tree-name').value.trim();
        const description = document.getElementById('tree-description').value.trim();
        
        if (!selectedSubcategoryId || !treeName) {
            alert('Please select a subcategory and enter a tree name');
            return;
        }
        
        const data = await apiPost('/api/tree', {
            subcategoryId: selectedSubcategoryId,
            treeName: treeName,
            description: description
        });
        
        if (data.success) {
            alert('Tree created successfully! Now add nodes to your tree.');
            resetTreeForm();
            editTree(data.treeId);
        } else {
            alert('Error: ' + data.error);
        }
    }
    
    function resetTreeForm() {
        selectedCategoryId = null;
        selectedSubcategoryId = null;
        document.getElementById('tree-name').value = '';
        document.getElementById('tree-description').value = '';
        loadCategoriesForSelection();
    }
    
    async function editTree(treeId) {
        currentTreeId = treeId;
        const data = await apiGet('/api/tree/' + treeId);
        
        if (data.success) {
            document.querySelectorAll('.section').forEach(s => s.style.display = 'none');
            document.getElementById('tree-editor-section').style.display = 'block';
            document.getElementById('editing-tree-name').textContent = 'Editing: ' + data.tree.treeName;
            
            renderTreeNodes(data.rootNode);
        } else {
            alert('Error loading tree: ' + data.error);
        }
    }
    
    async function viewTree(treeId) {
        currentTreeId = treeId;
        const data = await apiGet('/api/tree/' + treeId);
        
        if (data.success) {
            document.querySelectorAll('.section').forEach(s => s.style.display = 'none');
            document.getElementById('tree-editor-section').style.display = 'block';
            document.getElementById('editing-tree-name').textContent = 'Viewing: ' + data.tree.treeName;
            
            renderTreeNodes(data.rootNode, false);
        }
    }
    
    function closeTreeEditor() {
        currentTreeId = null;
        document.getElementById('tree-editor-section').style.display = 'none';
        document.getElementById('my-trees-section').style.display = 'block';
        loadMyTrees();
    }
    
    function confirmDeleteTree(treeId, treeName) {
        document.getElementById('delete-message').textContent = 'Are you sure you want to delete the tree "' + treeName + '"? This will also delete all nodes.';
        document.getElementById('confirm-delete-btn').onclick = async function() {
            const data = await apiDelete('/api/tree/' + treeId);
            if (data.success) {
                closeDeleteDialog();
                loadMyTrees();
            } else {
                alert('Error: ' + data.error);
            }
        };
        document.getElementById('delete-dialog').showModal();
    }
    
    // Node Rendering
    function renderTreeNodes(rootNode, canEdit) {
        if (canEdit === undefined) canEdit = true;
        const container = document.getElementById('tree-container');
        
        if (!rootNode) {
            container.innerHTML = 
                '<div class="empty-tree-state">' +
                    '<p>This tree has no nodes yet.</p>' +
                    (canEdit ? '<button class="btn-primary" onclick="addRootNode()">Add Root Node</button>' : '') +
                '</div>';
            return;
        }
        
        container.innerHTML = renderNode(rootNode, canEdit);
    }
    
    function renderNode(node, canEdit) {
        var nodeClass = node.nodeType === 'RESULT' ? 'result' : 'question';
        
        var html = 
            '<div class="tree-node-wrapper">' +
                '<div class="tree-node ' + nodeClass + '" onclick="event.stopPropagation()">' +
                    '<span class="node-type-badge">' + node.nodeType + '</span>' +
                    (node.optionLabel ? '<div class="node-label">↳ ' + escapeHtml(node.optionLabel) + '</div>' : '') +
                    '<div class="node-text">' + escapeHtml(node.nodeText) + '</div>' +
                    (canEdit ? 
                        '<div class="node-actions">' +
                            '<button class="node-action-btn add" onclick="openAddChildDialog(' + node.nodeId + ')">+ Add Child</button>' +
                            '<button class="node-action-btn edit" onclick="openEditNodeDialog(' + node.nodeId + ')">Edit</button>' +
                            '<button class="node-action-btn delete" onclick="confirmDeleteNode(' + node.nodeId + ')">Delete</button>' +
                        '</div>'
                    : '') +
                '</div>';
        
        if (node.children && node.children.length > 0) {
            html += '<div class="node-children">';
            for (var i = 0; i < node.children.length; i++) {
                html += renderNode(node.children[i], canEdit);
            }
            html += '</div>';
        }
        
        html += '</div>';
        return html;
    }
    
    // Node Dialog Management
    function addRootNode() {
        document.getElementById('dialog-title').textContent = 'Add Root Node';
        document.getElementById('node-id').value = '';
        document.getElementById('node-tree-id').value = currentTreeId;
        document.getElementById('node-parent-id').value = '';
        document.getElementById('node-option-label').value = '';
        document.getElementById('node-text').value = '';
        document.getElementById('node-type').value = 'QUESTION';
        document.getElementById('node-dialog').showModal();
    }
    
    function openAddChildDialog(parentId) {
        document.getElementById('dialog-title').textContent = 'Add Child Node';
        document.getElementById('node-id').value = '';
        document.getElementById('node-tree-id').value = currentTreeId;
        document.getElementById('node-parent-id').value = parentId;
        document.getElementById('node-option-label').value = '';
        document.getElementById('node-text').value = '';
        document.getElementById('node-type').value = 'QUESTION';
        document.getElementById('node-dialog').showModal();
    }
    
    async function openEditNodeDialog(nodeId) {
        const data = await apiGet('/api/node/' + nodeId);
        if (data.success) {
            document.getElementById('dialog-title').textContent = 'Edit Node';
            document.getElementById('node-id').value = data.node.nodeId;
            document.getElementById('node-tree-id').value = data.node.treeId;
            document.getElementById('node-parent-id').value = data.node.parentId || '';
            document.getElementById('node-option-label').value = data.node.optionLabel || '';
            document.getElementById('node-text').value = data.node.nodeText;
            document.getElementById('node-type').value = data.node.nodeType;
            document.getElementById('node-dialog').showModal();
        }
    }
    
    function closeNodeDialog() {
        document.getElementById('node-dialog').close();
    }
    
    async function saveNode() {
        const nodeId = document.getElementById('node-id').value;
        const treeId = parseInt(document.getElementById('node-tree-id').value);
        const parentId = document.getElementById('node-parent-id').value;
        const optionLabel = document.getElementById('node-option-label').value.trim();
        const nodeText = document.getElementById('node-text').value.trim();
        const nodeType = document.getElementById('node-type').value;
        
        if (!nodeText) {
            alert('Node text is required');
            return;
        }
        
        let data;
        if (nodeId) {
            // Update existing node
            data = await apiPut('/api/node', {
                nodeId: parseInt(nodeId),
                nodeText: nodeText,
                optionLabel: optionLabel,
                nodeType: nodeType
            });
        } else {
            // Create new node
            data = await apiPost('/api/node', {
                treeId: treeId,
                parentId: parentId ? parseInt(parentId) : null,
                nodeText: nodeText,
                optionLabel: optionLabel,
                nodeType: nodeType
            });
        }
        
        if (data.success) {
            closeNodeDialog();
            editTree(treeId);
        } else {
            alert('Error: ' + data.error);
        }
    }
    
    function confirmDeleteNode(nodeId) {
        document.getElementById('delete-message').textContent = 'Are you sure you want to delete this node? All child nodes will also be deleted.';
        document.getElementById('confirm-delete-btn').onclick = async function() {
            const data = await apiDelete('/api/node/' + nodeId);
            if (data.success) {
                closeDeleteDialog();
                editTree(currentTreeId);
            } else {
                alert('Error: ' + data.error);
            }
        };
        document.getElementById('delete-dialog').showModal();
    }
    
    function closeDeleteDialog() {
        document.getElementById('delete-dialog').close();
    }
    
    // Utility Functions
    function escapeHtml(text) {
        if (!text) return '';
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }
</script>

</body>
</html>
