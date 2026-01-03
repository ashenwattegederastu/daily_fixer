<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <%@ page import="com.dailyfixer.model.User" %>

            <% User user=(User) session.getAttribute("currentUser"); if (user==null || (!"admin".equals(user.getRole())
                && !"volunteer".equals(user.getRole()))) { response.sendRedirect(request.getContextPath() + "/login.jsp"
                ); return; } %>

                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Create Guide | Daily Fixer</title>
                    <link
                        href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap"
                        rel="stylesheet">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/framework.css">
                    <style>
                        .page-container {
                            max-width: 900px;
                            margin: 0 auto;
                            padding: 100px 30px 50px;
                        }

                        .page-header {
                            margin-bottom: 30px;
                        }

                        .page-header h1 {
                            font-size: 2rem;
                            color: var(--foreground);
                        }

                        .form-card {
                            background: var(--card);
                            border-radius: var(--radius-lg);
                            padding: 30px;
                            border: 1px solid var(--border);
                            margin-bottom: 25px;
                        }

                        .form-card h2 {
                            font-size: 1.3rem;
                            color: var(--primary);
                            margin-bottom: 20px;
                            padding-bottom: 10px;
                            border-bottom: 2px solid var(--border);
                        }

                        .form-group {
                            margin-bottom: 20px;
                        }

                        .form-group label {
                            display: block;
                            margin-bottom: 8px;
                            font-weight: 600;
                            color: var(--foreground);
                        }

                        .form-group input[type="text"],
                        .form-group input[type="url"],
                        .form-group select,
                        .form-group textarea {
                            width: 100%;
                            padding: 12px 15px;
                            border: 2px solid var(--border);
                            border-radius: var(--radius-md);
                            background: var(--input);
                            color: var(--foreground);
                            font-size: 1rem;
                            font-family: inherit;
                        }

                        .form-group input:focus,
                        .form-group select:focus,
                        .form-group textarea:focus {
                            outline: none;
                            border-color: var(--primary);
                        }

                        .form-group textarea {
                            min-height: 120px;
                            resize: vertical;
                        }

                        .form-group small {
                            color: var(--muted-foreground);
                            font-size: 0.85rem;
                        }

                        .category-row {
                            display: grid;
                            grid-template-columns: 1fr 1fr;
                            gap: 20px;
                        }

                        .dynamic-list {
                            margin-top: 10px;
                        }

                        .dynamic-item {
                            display: flex;
                            gap: 10px;
                            margin-bottom: 10px;
                        }

                        .dynamic-item input {
                            flex: 1;
                        }

                        .add-btn,
                        .remove-btn {
                            padding: 8px 15px;
                            border: none;
                            border-radius: var(--radius-md);
                            cursor: pointer;
                            font-weight: 500;
                        }

                        .add-btn {
                            background: var(--secondary);
                            color: var(--secondary-foreground);
                            border: 1px solid var(--border);
                        }

                        .remove-btn {
                            background: var(--destructive);
                            color: var(--destructive-foreground);
                        }

                        .step-card {
                            background: var(--muted);
                            border-radius: var(--radius-md);
                            padding: 20px;
                            margin-bottom: 20px;
                            position: relative;
                        }

                        .step-card-header {
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            margin-bottom: 15px;
                        }

                        .step-number {
                            font-weight: 700;
                            color: var(--primary);
                        }

                        .image-preview {
                            max-width: 200px;
                            max-height: 150px;
                            object-fit: cover;
                            border-radius: var(--radius-sm);
                            margin-top: 10px;
                        }

                        .form-actions {
                            display: flex;
                            gap: 15px;
                            justify-content: flex-end;
                            margin-top: 30px;
                        }

                        .error-message {
                            background: var(--destructive);
                            color: var(--destructive-foreground);
                            padding: 15px;
                            border-radius: var(--radius-md);
                            margin-bottom: 20px;
                        }

                        @media (max-width: 600px) {
                            .category-row {
                                grid-template-columns: 1fr;
                            }
                        }
                    </style>
                </head>

                <body>
                    <!-- Navigation -->
                    <nav id="navbar" class="public-nav">
                        <div class="nav-container">
                            <a href="${pageContext.request.contextPath}/index.jsp" class="logo">Daily Fixer</a>
                            <ul class="nav-links">
                                <li><a href="${pageContext.request.contextPath}/guides">View Repair Guides</a></li>
                            </ul>
                            <div class="nav-buttons">
                                <button id="theme-toggle-btn" class="theme-toggle" onclick="toggleTheme()">🌙
                                    Dark</button>
                                <a href="${pageContext.request.contextPath}/pages/dashboards/${sessionScope.currentUser.role}dash/${sessionScope.currentUser.role}dashmain.jsp"
                                    class="btn-login" style="text-decoration: none; padding: 0.6rem 1.2rem;">
                                    Hi, ${sessionScope.currentUser.firstName}
                                </a>
                                <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
                            </div>
                        </div>
                    </nav>

                    <div class="page-container">
                        <div class="page-header">
                            <h1>Create New Guide</h1>
                        </div>

                        <c:if test="${not empty error}">
                            <div class="error-message">${error}</div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/guides/create" method="post"
                            enctype="multipart/form-data" id="guideForm">

                            <!-- Basic Information -->
                            <div class="form-card">
                                <h2>📝 Basic Information</h2>
                                <div class="form-group">
                                    <label for="title">Guide Title *</label>
                                    <input type="text" id="title" name="title" required
                                        placeholder="e.g., How to Fix a Leaking Faucet">
                                </div>
                                <div class="form-group">
                                    <label for="mainImage">Main Image</label>
                                    <input type="file" id="mainImage" name="mainImage" accept="image/*"
                                        onchange="previewMainImage(this)">
                                    <img id="mainImagePreview" class="image-preview" style="display:none;">
                                </div>
                                <div class="category-row">
                                    <div class="form-group">
                                        <label for="mainCategory">Main Category *</label>
                                        <select id="mainCategory" name="mainCategory" required
                                            onchange="updateSubCategories()">
                                            <option value="">Select Category</option>
                                            <option value="Home Repair">Home Repair</option>
                                            <option value="Home Electronics / Appliance Repair">Home Electronics /
                                                Appliances</option>
                                            <option value="Vehicle Repair">Vehicle Repair</option>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label for="subCategory">Sub-Category *</label>
                                        <select id="subCategory" name="subCategory" required>
                                            <option value="">Select Sub-Category</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="youtubeUrl">YouTube Video URL (Optional)</label>
                                    <input type="url" id="youtubeUrl" name="youtubeUrl"
                                        placeholder="https://www.youtube.com/watch?v=...">
                                    <small>If provided, the video will be embedded in the guide</small>
                                </div>
                            </div>

                            <!-- Requirements -->
                            <div class="form-card">
                                <h2>🔧 Things You Need</h2>
                                <p style="color: var(--muted-foreground); margin-bottom: 15px;">List the tools,
                                    materials, or parts needed to follow this guide.</p>
                                <div id="requirementsList" class="dynamic-list">
                                    <div class="dynamic-item">
                                        <input type="text" name="requirements" placeholder="e.g., Adjustable wrench">
                                        <button type="button" class="remove-btn" onclick="removeItem(this)">✕</button>
                                    </div>
                                </div>
                                <button type="button" class="add-btn" onclick="addRequirement()">+ Add
                                    Requirement</button>
                            </div>

                            <!-- Steps -->
                            <div class="form-card">
                                <h2>📋 Guide Steps</h2>
                                <p style="color: var(--muted-foreground); margin-bottom: 15px;">Add step-by-step
                                    instructions with images.</p>
                                <div id="stepsList">
                                    <div class="step-card" data-step="0">
                                        <div class="step-card-header">
                                            <span class="step-number">Step 1</span>
                                            <button type="button" class="remove-btn" onclick="removeStep(this)">Remove
                                                Step</button>
                                        </div>
                                        <div class="form-group">
                                            <label>Step Title *</label>
                                            <input type="text" name="stepTitle" required
                                                placeholder="e.g., Turn off the water supply">
                                        </div>
                                        <div class="form-group">
                                            <label>Step Images</label>
                                            <input type="file" name="stepImage_0" accept="image/*" multiple>
                                        </div>
                                        <div class="form-group">
                                            <label>Step Description</label>
                                            <textarea name="stepBody"
                                                placeholder="Describe what to do in this step..."></textarea>
                                        </div>
                                    </div>
                                </div>
                                <button type="button" class="add-btn" onclick="addStep()">+ Add Step</button>
                            </div>

                            <div class="form-actions">
                                <a href="${pageContext.request.contextPath}/guides" class="btn-secondary">Cancel</a>
                                <button type="submit" class="btn-primary">Create Guide</button>
                            </div>
                        </form>
                    </div>

                    <script src="${pageContext.request.contextPath}/assets/js/dark-mode.js"></script>
                    <script>
                        const subCategories = {
                            'Home Repair': ['Plumbing', 'Electrical', 'Masonry', 'Painting & Finishing', 'Carpentry', 'Roofing',
                                'Flooring & Tiling', 'Doors & Windows', 'Ceiling & False Ceiling', 'Waterproofing',
                                'Glass & Mirrors', 'Locks & Hardware'],
                            'Home Electronics / Appliance Repair': ['Refrigerator', 'Washing Machine', 'Microwave Oven', 'Electric Kettle',
                                'Rice Cooker', 'Mixer / Blender', 'Air Conditioner', 'Water Heater',
                                'Fans', 'Television', 'Home Theatre / Speakers', 'Inverter / UPS',
                                'Voltage Stabilizer'],
                            'Vehicle Repair': ['Engine System', 'Fuel System', 'Electrical System', 'Battery & Charging', 'Transmission',
                                'Clutch System', 'Brake System', 'Steering System', 'Suspension System', 'Tyres & Wheels',
                                'Cooling System', 'Exhaust System', 'Body & Interior']
                        };

                        function updateSubCategories() {
                            const mainCat = document.getElementById('mainCategory').value;
                            const subSelect = document.getElementById('subCategory');
                            subSelect.innerHTML = '<option value="">Select Sub-Category</option>';

                            if (mainCat && subCategories[mainCat]) {
                                subCategories[mainCat].forEach(sub => {
                                    const option = document.createElement('option');
                                    option.value = sub;
                                    option.textContent = sub;
                                    subSelect.appendChild(option);
                                });
                            }
                        }

                        function previewMainImage(input) {
                            if (input.files && input.files[0]) {
                                const reader = new FileReader();
                                reader.onload = function (e) {
                                    const preview = document.getElementById('mainImagePreview');
                                    preview.src = e.target.result;
                                    preview.style.display = 'block';
                                };
                                reader.readAsDataURL(input.files[0]);
                            }
                        }

                        function addRequirement() {
                            const list = document.getElementById('requirementsList');
                            const div = document.createElement('div');
                            div.className = 'dynamic-item';
                            div.innerHTML = `
            <input type="text" name="requirements" placeholder="e.g., Screwdriver">
            <button type="button" class="remove-btn" onclick="removeItem(this)">✕</button>
        `;
                            list.appendChild(div);
                        }

                        function removeItem(btn) {
                            btn.parentElement.remove();
                        }

                        let stepCount = 1;

                        function addStep() {
                            const list = document.getElementById('stepsList');
                            const div = document.createElement('div');
                            div.className = 'step-card';
                            div.dataset.step = stepCount;
                            div.innerHTML = `
            <div class="step-card-header">
                <span class="step-number">Step ${stepCount + 1}</span>
                <button type="button" class="remove-btn" onclick="removeStep(this)">Remove Step</button>
            </div>
            <div class="form-group">
                <label>Step Title *</label>
                <input type="text" name="stepTitle" required placeholder="e.g., Remove the old part">
            </div>
            <div class="form-group">
                <label>Step Images</label>
                <input type="file" name="stepImage_${stepCount}" accept="image/*" multiple>
            </div>
            <div class="form-group">
                <label>Step Description</label>
                <textarea name="stepBody" placeholder="Describe what to do in this step..."></textarea>
            </div>
        `;
                            list.appendChild(div);
                            stepCount++;
                            renumberSteps();
                        }

                        function removeStep(btn) {
                            const stepCards = document.querySelectorAll('.step-card');
                            if (stepCards.length > 1) {
                                btn.closest('.step-card').remove();
                                renumberSteps();
                            } else {
                                alert('A guide must have at least one step.');
                            }
                        }

                        function renumberSteps() {
                            const stepCards = document.querySelectorAll('.step-card');
                            stepCards.forEach((card, index) => {
                                card.querySelector('.step-number').textContent = 'Step ' + (index + 1);
                                card.dataset.step = index;
                                // Update the file input name to match the new index
                                const fileInput = card.querySelector('input[type="file"]');
                                if (fileInput) {
                                    fileInput.name = 'stepImage_' + index;
                                }
                            });
                        }
                    </script>
                </body>

                </html>