<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.dailyfixer.model.User" %>

<%
  User currentUser = (User) session.getAttribute("currentUser");
  if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
    response.sendRedirect(request.getContextPath() + "/pages/shared/login.jsp");
    return;
  }
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Add New Guide | Admin Dashboard</title>
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/framework.css">
  <style>
  .form-container {
      background: var(--card);
      border-radius: var(--radius-lg);
      padding: 30px;
      box-shadow: var(--shadow-sm);
      border: 1px solid var(--border);
      margin-top: 20px;
      max-width: 900px;
  }
  .form-section {
      margin-bottom: 30px;
      padding: 20px;
      background: var(--muted);
      border-radius: var(--radius-md);
      border-left: 4px solid var(--primary);
  }
  .form-section h3 {
      color: var(--foreground);
      margin-bottom: 15px;
      font-size: 1.2em;
  }
  .form-group {
      margin-bottom: 20px;
  }
  label {
      display: block;
      margin-bottom: 8px;
      font-weight: 500;
      color: var(--foreground);
  }
  input[type="text"], input[type="url"], textarea, input[type="file"], select {
      width: 100%;
      padding: 12px;
      border-radius: var(--radius-md);
      border: 2px solid var(--border);
      font-family: inherit;
      font-size: 0.9em;
      transition: border-color 0.2s;
      background: var(--input);
      color: var(--foreground);
  }
  input[type="text"]:focus, input[type="url"]:focus, textarea:focus, select:focus {
      outline: none;
      border-color: var(--primary);
  }
  textarea {
      resize: vertical;
      min-height: 80px;
  }
  .rich-text-editor {
      min-height: 150px;
      border: 2px solid var(--border);
      border-radius: var(--radius-md);
      padding: 12px;
      background: var(--input);
      color: var(--foreground);
  }
  .rich-text-editor:focus {
      outline: none;
      border-color: var(--primary);
  }
  .add-btn {
      display: inline-block;
      margin-top: 10px;
      padding: 8px 16px;
      background: var(--primary);
      color: var(--primary-foreground);
      font-weight: 500;
      border-radius: var(--radius-md);
      cursor: pointer;
      border: none;
      font-size: 0.9em;
      transition: all 0.2s;
  }
  .add-btn:hover {
      opacity: 0.9;
      transform: translateY(-1px);
  }
  .submit-btn {
      margin-top: 25px;
      padding: 12px 30px;
      background: var(--primary);
      color: var(--primary-foreground);
      border: none;
      border-radius: var(--radius-md);
      font-weight: 600;
      cursor: pointer;
      transition: all 0.2s;
      font-size: 1em;
      box-shadow: var(--shadow-sm);
  }
  .submit-btn:hover {
      opacity: 0.9;
      transform: translateY(-2px);
      box-shadow: var(--shadow-md);
  }
  .back-btn {
      display: inline-block;
      margin-right: 15px;
      padding: 12px 20px;
      background: var(--secondary);
      color: var(--secondary-foreground);
      font-weight: 500;
      border-radius: var(--radius-md);
      text-decoration: none;
      transition: all 0.2s;
      font-size: 0.9em;
      border: 1px solid var(--border);
  }
  .back-btn:hover {
      background: var(--accent);
      transform: translateY(-1px);
  }
  .step-item {
      background: var(--card);
      padding: 15px;
      border-radius: var(--radius-md);
      margin-bottom: 15px;
      border: 1px solid var(--border);
  }
  .remove-btn {
      background: var(--destructive);
      color: var(--destructive-foreground);
      border: none;
      padding: 5px 10px;
      border-radius: var(--radius-sm);
      cursor: pointer;
      font-size: 0.8em;
      margin-top: 10px;
  }
  </style>
</head>
<body>

<header class="topbar">
    <a href="${pageContext.request.contextPath}/index.jsp" class="logo">Daily Fixer</a>
    <div class="panel-name">Admin Panel</div>
    <div style="display: flex; align-items: center; gap: 10px;">
        <button id="theme-toggle-btn" class="theme-toggle" onclick="toggleTheme()" aria-label="Toggle dark mode">🌙 Dark</button>
        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Log Out</a>
    </div>
</header>

<aside class="sidebar">
    <h3>Navigation</h3>
    <ul>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/admindash/admindashmain.jsp">Dashboard</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/users">User Management</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/admindash/guides.jsp" class="active">View All Guides</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/admindash/flags.jsp">Flags</a></li>
        <li><a href="${pageContext.request.contextPath}/pages/dashboards/admindash/transactions.jsp">Transactions</a></li>
    </ul>
</aside>

<main class="main-content">
    <div class="dashboard-header">
        <h1>Add New Guide</h1>
        <p>Create a helpful guide to assist users with their daily repair needs</p>
    </div>

    <div class="form-container">
        <form action="${pageContext.request.contextPath}/AddGuideServlet" method="post" enctype="multipart/form-data">

            <div class="form-section">
                <h3>Step 1: Basic Information</h3>
                <div class="form-group">
                    <label for="title">Guide Title *</label>
                    <input type="text" id="title" name="title" required placeholder="Enter a descriptive title for your guide">
                </div>
                <div class="form-group">
                    <label for="mainImage">Main Image *</label>
                    <input type="file" id="mainImage" name="mainImage" accept="image/*" required>
                </div>
                <div class="form-group">
                    <label for="mainCategory">Main Category *</label>
                    <select id="mainCategory" name="mainCategory" required onchange="updateSubCategories()">
                        <option value="">Select a category</option>
                        <option value="Home Repair">🏠 Home Repair</option>
                        <option value="Home Electronics">🔌 Home Electronics / Appliance Repair</option>
                        <option value="Vehicle Repair">🚗 Vehicle Repair</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="subCategory">Subcategory *</label>
                    <select id="subCategory" name="subCategory" required>
                        <option value="">Select a subcategory</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="youtubeUrl">YouTube Video URL (Optional)</label>
                    <input type="url" id="youtubeUrl" name="youtubeUrl" placeholder="https://www.youtube.com/watch?v=...">
                </div>
            </div>

            <div class="form-section">
                <h3>Step 2: Things You Need</h3>
                <p style="color: var(--muted-foreground); margin-bottom: 15px;">List the tools, materials, and items needed to follow this guide</p>
                <div id="reqDiv">
                    <div class="form-group req-item">
                        <input type="text" name="requirements" placeholder="e.g., Screwdriver, Wrench, Replacement parts...">
                    </div>
                </div>
                <button type="button" onclick="addReq()" class="add-btn">+ Add Another Item</button>
            </div>

            <div class="form-section">
                <h3>Step 3: Guide Steps</h3>
                <p style="color: var(--muted-foreground); margin-bottom: 15px;">Add detailed steps for your repair guide</p>
                <div id="stepsDiv">
                    <div class="step-item">
                        <div class="form-group">
                            <label>Step Title *</label>
                            <input type="text" name="stepTitle" placeholder="Enter step title" required>
                        </div>
                        <div class="form-group">
                            <label>Step Description</label>
                            <div class="rich-text-editor" contenteditable="true" data-name="stepBody" placeholder="Provide detailed instructions for this step"></div>
                            <input type="hidden" name="stepBody">
                        </div>
                        <div class="form-group">
                            <label>Step Image</label>
                            <input type="file" name="stepImage" accept="image/*">
                        </div>
                    </div>
                </div>
                <button type="button" onclick="addStep()" class="add-btn">+ Add Another Step</button>
            </div>

            <div style="margin-top: 30px;">
                <button type="submit" class="submit-btn" onclick="prepareSubmit()">Submit Guide</button>
                <a href="${pageContext.request.contextPath}/pages/dashboards/admindash/guides.jsp" class="back-btn">← Back to Guides</a>
            </div>
        </form>
    </div>
</main>

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
    subCatSelect.innerHTML = '<option value="">Select a subcategory</option>';
    
    if (mainCat && subCategories[mainCat]) {
        subCategories[mainCat].forEach(sub => {
            const option = document.createElement('option');
            option.value = sub;
            option.textContent = sub;
            subCatSelect.appendChild(option);
        });
    }
}

function addReq() {
    const div = document.createElement("div");
    div.className = "form-group req-item";
    div.innerHTML = '<input type="text" name="requirements" placeholder="e.g., Screwdriver, Wrench, Replacement parts...">' +
                    '<button type="button" onclick="this.parentElement.remove()" class="remove-btn">Remove</button>';
    document.getElementById("reqDiv").appendChild(div);
}

let stepCount = 1;
function addStep() {
    stepCount++;
    const div = document.createElement("div");
    div.className = "step-item";
    div.innerHTML = `
      <div class="form-group">
        <label>Step Title *</label>
        <input type="text" name="stepTitle" placeholder="Enter step title" required>
      </div>
      <div class="form-group">
        <label>Step Description</label>
        <div class="rich-text-editor" contenteditable="true" data-name="stepBody" placeholder="Provide detailed instructions for this step"></div>
        <input type="hidden" name="stepBody">
      </div>
      <div class="form-group">
        <label>Step Image</label>
        <input type="file" name="stepImage" accept="image/*">
      </div>
      <button type="button" onclick="this.parentElement.remove()" class="remove-btn">Remove Step</button>`;
    document.getElementById("stepsDiv").appendChild(div);
}

function prepareSubmit() {
    document.querySelectorAll('.rich-text-editor').forEach((editor, index) => {
        const hiddenInputs = document.querySelectorAll('input[name="stepBody"]');
        if (hiddenInputs[index]) {
            hiddenInputs[index].value = editor.innerHTML;
        }
    });
}
</script>
<script src="${pageContext.request.contextPath}/assets/js/dark-mode.js"></script>
</body>
</html>
