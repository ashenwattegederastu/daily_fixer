<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <title>Add New Guide - DailyFixer</title>
  <style>
    body {
      background: linear-gradient(to bottom, #ffffff, #c8d9ff);
      font-family: Arial, sans-serif;
      color: #333;
      line-height: 1.6;
      margin: 0;
      padding: 0;
    }

    header {
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      z-index: 1000;
    }

    .navbar {
      display: flex;
      justify-content: space-between;
      align-items: center;
      background-color: #7c8cff;
      padding: 10px 30px;
      border-top-left-radius: 10px;
      border-top-right-radius: 10px;
    }

    .logo {
      font-size: 22px;
      font-weight: bold;
      color: white;
    }

    .nav-links {
      list-style: none;
      display: flex;
      gap: 30px;
      margin: 0;
      padding: 0;
    }

    .nav-links li a {
      text-decoration: none;
      color: white;
      font-weight: bold;
    }

    .subnav {
      background-color: #cfe0ff;
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 12px 20px;
      border-radius: 50px;
      margin-top: 5px;
      border: 1px solid #a6c0ff;
      gap: 10px;
    }

    .subnav .store-name {
      font-weight: bold;
      font-size: 20px;
    }

    .subnav ul {
      list-style: none;
      display: flex;
      gap: 2rem;
      margin: 0;
      padding: 0;
    }

    .subnav a {
      text-decoration: none;
      color: #333;
      font-weight: 500;
    }

    .container {
      max-width: 800px;
      margin: 150px auto 50px auto;
      padding: 0 15px;
    }

    .form-container {
      background: white;
      padding: 30px;
      border-radius: 12px;
      box-shadow: 0 3px 8px rgba(0,0,0,0.1);
    }

    .form-container h2 {
      margin-bottom: 20px;
      color: #003366;
    }

    .wizard-step {
      display: none;
    }

    .wizard-step.active {
      display: block;
    }

    .progress-bar {
      display: flex;
      justify-content: space-between;
      margin-bottom: 30px;
      position: relative;
    }

    .progress-bar::before {
      content: '';
      position: absolute;
      top: 20px;
      left: 0;
      right: 0;
      height: 2px;
      background: #ddd;
      z-index: 0;
    }

    .progress-step {
      flex: 1;
      text-align: center;
      position: relative;
      z-index: 1;
    }

    .progress-step-circle {
      width: 40px;
      height: 40px;
      border-radius: 50%;
      background: #ddd;
      color: #666;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      font-weight: bold;
      margin-bottom: 5px;
    }

    .progress-step.active .progress-step-circle {
      background: #7c8cff;
      color: white;
    }

    .progress-step.completed .progress-step-circle {
      background: #4caf50;
      color: white;
    }

    .progress-step-label {
      font-size: 12px;
      color: #666;
    }

    label {
      display: block;
      margin-top: 15px;
      font-weight: bold;
    }

    input[type="text"], textarea, input[type="file"] {
      width: 100%;
      padding: 10px;
      border-radius: 8px;
      border: 1px solid #ccc;
      margin-top: 5px;
      box-sizing: border-box;
    }

    textarea {
      resize: vertical;
      min-height: 80px;
    }

    .btn-group {
      margin-top: 25px;
      display: flex;
      gap: 10px;
      justify-content: space-between;
    }

    .btn {
      padding: 12px 25px;
      border: none;
      border-radius: 10px;
      font-weight: bold;
      cursor: pointer;
      transition: 0.2s;
    }

    .btn-primary {
      background: #7c8cff;
      color: white;
    }

    .btn-primary:hover {
      background: #6b7aff;
    }

    .btn-secondary {
      background: #ddd;
      color: #333;
    }

    .btn-secondary:hover {
      background: #ccc;
    }

    .btn-success {
      background: #4caf50;
      color: white;
    }

    .btn-success:hover {
      background: #45a049;
    }

    .add-btn {
      display: inline-block;
      margin-top: 10px;
      padding: 8px 15px;
      background: #7c8cff;
      color: white;
      font-weight: bold;
      border-radius: 8px;
      cursor: pointer;
      border: none;
    }

    .add-btn:hover {
      background: #6b7aff;
    }

    .requirement-item, .step-item {
      margin-bottom: 10px;
      padding: 10px;
      background: #f9f9f9;
      border-radius: 8px;
    }

    .step-container {
      border: 1px solid #ddd;
      padding: 15px;
      margin: 15px 0;
      border-radius: 8px;
      background: #f9f9f9;
    }

    .image-preview {
      max-width: 200px;
      margin: 10px 0;
      border-radius: 8px;
    }
  </style>
</head>
<body>

<header>
  <div class="navbar">
    <div class="logo">DailyFixer</div>
    <ul class="nav-links">
      <li><a href="${pageContext.request.contextPath}">Home</a></li>
      <li><a href="${pageContext.request.contextPath}/logout">Log Out</a></li>
    </ul>
  </div>
  <div class="subnav">
    <div class="store-name">Volunteer Dashboard</div>
    <ul>
      <li><a href="${pageContext.request.contextPath}/pages/dashboards/volunteerdash/volunteerdashmain.jsp">Dashboard</a></li>
      <li><a href="${pageContext.request.contextPath}/pages/dashboards/volunteerdash/myguides.jsp" class="active">My Guides</a></li>
      <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/myProfile.jsp">Profile</a></li>
    </ul>
  </div>
</header>

<div class="container">
  <div class="form-container">
    <h2>Add New Guide</h2>
    
    <!-- Progress Bar -->
    <div class="progress-bar">
      <div class="progress-step active" id="progress-1">
        <div class="progress-step-circle">1</div>
        <div class="progress-step-label">Basic Info</div>
      </div>
      <div class="progress-step" id="progress-2">
        <div class="progress-step-circle">2</div>
        <div class="progress-step-label">Requirements</div>
      </div>
      <div class="progress-step" id="progress-3">
        <div class="progress-step-circle">3</div>
        <div class="progress-step-label">Steps</div>
      </div>
    </div>

    <form id="guideForm" action="${pageContext.request.contextPath}/AddGuideServlet" method="post" enctype="multipart/form-data">

      <!-- Step 1: Basic Info -->
      <div class="wizard-step active" id="step-1">
        <h3>Step 1: Basic Information</h3>
        <label>Guide Title: *</label>
        <input type="text" id="title" name="title" required>

        <label>Title Image: *</label>
        <input type="file" id="mainImage" name="mainImage" accept="image/*" required onchange="previewImage(this, 'mainImagePreview')">
        <img id="mainImagePreview" class="image-preview" style="display:none;">

        <div class="btn-group">
          <a href="${pageContext.request.contextPath}/pages/dashboards/volunteerdash/myguides.jsp" class="btn btn-secondary">Cancel</a>
          <button type="button" class="btn btn-primary" onclick="nextStep(2)">Next →</button>
        </div>
      </div>

      <!-- Step 2: Requirements -->
      <div class="wizard-step" id="step-2">
        <h3>Step 2: Requirements</h3>
        <p>Add the tools or materials needed for this guide.</p>
        <div id="reqDiv">
          <div class="requirement-item">
            <input type="text" name="requirements" placeholder="Enter a requirement (e.g., Screwdriver, Wrench)">
          </div>
        </div>
        <button type="button" onclick="addReq()" class="add-btn">+ Add Another Requirement</button>

        <div class="btn-group">
          <button type="button" class="btn btn-secondary" onclick="prevStep(1)">← Back</button>
          <button type="button" class="btn btn-primary" onclick="nextStep(3)">Next →</button>
        </div>
      </div>

      <!-- Step 3: Steps -->
      <div class="wizard-step" id="step-3">
        <h3>Step 3: Add Guide Steps</h3>
        <p>Add at least one step to your guide. You can add more steps as needed.</p>
        <div id="stepsDiv">
          <div class="step-container">
            <h4>Step 1</h4>
            <label>Step Title: *</label>
            <input type="text" name="stepTitle" placeholder="e.g., Remove the back cover" required>

            <label>Step Description: *</label>
            <textarea name="stepDescription" placeholder="Describe what to do in this step..." required></textarea>

            <label>Step Image:</label>
            <input type="file" name="stepImage" accept="image/*" onchange="previewStepImage(this)">
            <img class="step-image-preview image-preview" style="display:none;">
          </div>
        </div>
        <button type="button" onclick="addStep()" class="add-btn">+ Add Another Step</button>

        <div class="btn-group">
          <button type="button" class="btn btn-secondary" onclick="prevStep(2)">← Back</button>
          <button type="submit" class="btn btn-success">Finish Guide</button>
        </div>
      </div>

    </form>
  </div>
</div>

<script>
  let currentStep = 1;
  let stepCount = 1;

  function nextStep(step) {
    // Validate current step
    if (currentStep === 1) {
      const title = document.getElementById('title').value;
      const mainImage = document.getElementById('mainImage').files.length;
      if (!title || !mainImage) {
        alert('Please fill in the title and upload an image.');
        return;
      }
    } else if (currentStep === 3) {
      // Validate at least one step
      const stepTitles = document.getElementsByName('stepTitle');
      const stepDescriptions = document.getElementsByName('stepDescription');
      if (stepTitles.length === 0 || !stepTitles[0].value || !stepDescriptions[0].value) {
        alert('Please add at least one step with a title and description.');
        return;
      }
    }

    // Hide current step
    document.getElementById('step-' + currentStep).classList.remove('active');
    document.getElementById('progress-' + currentStep).classList.remove('active');
    document.getElementById('progress-' + currentStep).classList.add('completed');

    // Show next step
    currentStep = step;
    document.getElementById('step-' + currentStep).classList.add('active');
    document.getElementById('progress-' + currentStep).classList.add('active');

    // Scroll to top
    window.scrollTo(0, 0);
  }

  function prevStep(step) {
    // Hide current step
    document.getElementById('step-' + currentStep).classList.remove('active');
    document.getElementById('progress-' + currentStep).classList.remove('active');

    // Show previous step
    currentStep = step;
    document.getElementById('step-' + currentStep).classList.add('active');
    document.getElementById('progress-' + currentStep).classList.remove('completed');
    document.getElementById('progress-' + currentStep).classList.add('active');

    // Scroll to top
    window.scrollTo(0, 0);
  }

  function addReq() {
    const div = document.createElement("div");
    div.className = "requirement-item";
    div.innerHTML = '<input type="text" name="requirements" placeholder="Enter a requirement">';
    document.getElementById("reqDiv").appendChild(div);
  }

  function addStep() {
    stepCount++;
    const div = document.createElement("div");
    div.className = "step-container";
    div.innerHTML = `
      <h4>Step ${stepCount}</h4>
      <label>Step Title: *</label>
      <input type="text" name="stepTitle" placeholder="e.g., Remove the back cover" required>
      <label>Step Description: *</label>
      <textarea name="stepDescription" placeholder="Describe what to do in this step..." required></textarea>
      <label>Step Image:</label>
      <input type="file" name="stepImage" accept="image/*" onchange="previewStepImage(this)">
      <img class="step-image-preview image-preview" style="display:none;">
    `;
    document.getElementById("stepsDiv").appendChild(div);
  }

  function previewImage(input, previewId) {
    const preview = document.getElementById(previewId);
    if (input.files && input.files[0]) {
      const reader = new FileReader();
      reader.onload = function(e) {
        preview.src = e.target.result;
        preview.style.display = 'block';
      };
      reader.readAsDataURL(input.files[0]);
    }
  }

  function previewStepImage(input) {
    const preview = input.nextElementSibling;
    if (input.files && input.files[0]) {
      const reader = new FileReader();
      reader.onload = function(e) {
        preview.src = e.target.result;
        preview.style.display = 'block';
      };
      reader.readAsDataURL(input.files[0]);
    }
  }
</script>

</body>
</html>
