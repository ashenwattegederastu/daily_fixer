<html>
<head>
  <title>Daily Fixer</title>
  <!-- Link to external stylesheet -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/findtech.css">
</head>
<body>
<header>

  <!-- Main Navbar -->
  <nav class="navbar">
    <div class="logo">Daily Fixer</div>
    <ul class="nav-links">
      <li><a href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
      <li><a href="${pageContext.request.contextPath}/login">Log in</a></li>
    </ul>
  </nav>

  <!-- Rounded Subnav -->
  <div class="subnav">
    <a href="${pageContext.request.contextPath}/diagnostic.jsp" >Diagnose Now</a>
    <a href="${pageContext.request.contextPath}/findtech.jsp" class="active">Find a Technician</a>
    <a href="${pageContext.request.contextPath}/viewguides.jsp">View Repair Guides</a>
    <a href="${pageContext.request.contextPath}/store.jsp">Stores</a>
  </div>
</header>

<!-- Main Content -->
<div class="container">
  <h2 class="page-title">Technician</h2>
  <div class="search-section">
    <h3 class="issue-title">Find a Technician</h3>
    <div class="search-box">
      <input type="text" id="searchInput" placeholder="Search for a technician" onkeyup="filterTechnicians()">
      <button onclick="filterTechnicians()">
        <img src="${pageContext.request.contextPath}/assets/images/pictures/search.png" alt="Search">
      </button>
    </div>
    <p class="instruction-text">Use the filters to narrow down your search based on specialization, ratings, availability, and service area</p>
  </div>

  <!-- Filters -->
  <div class="filters">
    <label>
      <select id="specializationFilter">
        <option value="">Specialization</option>
        <option value="Plumbing">Plumbing</option>
        <option value="Electrical">Electrical</option>
        <option value="Carpentry">Flooring</option>
        <option value="Carpentry">Flooring</option>
        <option value="Carpentry">Roofing and Guttering</option>
        <option value="Carpentry">Painting and Wall repairs</option>
        <option value="Carpentry">Furniture repair and Assembly</option>
      </select>

      <select id="ratingsFilter">
        <option value="">Ratings</option>
        <option value="5">5 Stars</option>
        <option value="4">4 Stars & above</option>
        <option value="3">3 Stars & above</option>
      </select>

      <select id="availabilityFilter">
        <option value="">Availability</option>
        <option value="Today">Today</option>
        <option value="This Week">This Week</option>
        <option value="Weekends">Weekends</option>
      </select>

      <select id="serviceAreaFilter">
        <option value="">Service Area</option>
        <option value="Colombo">Colombo</option>
        <option value="Galle">Galle</option>
        <option value="Kandy">Kandy</option>
      </select>
    </label>
    <!-- Filter Button -->
    <button class="apply-filters" onclick="filterTechnicians()">Apply Filters</button>
  </div>

  <!-- Technicians List -->
  <div class="technicians" id="technicianList">
    <div class="technician-card"
         data-specialization="Plumbing, Electrical"
         data-rating="4.5"
         data-availability="Today"
         data-servicearea="Colombo">
      <img src="${pageContext.request.contextPath}/assets/images/pictures/profile_tech.jpg" alt="Technician">
      <div class="technician-details">
        <h3>Alex Johnson <img src="${pageContext.request.contextPath}/assets/images/icons/verify.png" alt="verify"></h3>
        <p>Rating: 4.5 (20 reviews)</p>
        <p>Plumbing, Electrical</p>
        <button onclick="viewDetails('${pageContext.request.contextPath}/tech_alex.jsp')">View Details</button>
      </div>
    </div>

    <div class="technician-card"
         data-specialization="Carpentry, Plumbing"
         data-rating="4.7"
         data-availability="This Week"
         data-servicearea="Galle">
      <img src="${pageContext.request.contextPath}/assets/images/pictures/profile_plumber.jpg" alt="Technician">
      <div class="technician-details">
        <h3>Michael Lee <img src="${pageContext.request.contextPath}/assets/images/icons/verify.png" alt="verify"></h3>
        <p>Rating: 4.7 (15 reviews)</p>
        <p>Carpentry, Plumbing</p>
        <button onclick="viewDetails('technician_michael.html')">View Details</button>
      </div>
    </div>

    <div class="technician-card"
         data-specialization="Electrical"
         data-rating="4.8"
         data-availability="Weekends"
         data-servicearea="Kandy">
      <img src="${pageContext.request.contextPath}/assets/images/pictures/Progile_elec.jpg" alt="Technician">
      <div class="technician-details">
        <h3>Sarah Kim <img src="${pageContext.request.contextPath}/assets/images/icons/verify.png" alt="verify"></h3>
        <p>Rating: 4.8 (30 reviews)</p>
        <p>Electrical</p>
        <button onclick="viewDetails('technician_sarah.html')">View Details</button>
      </div>
    </div>

    <div class="technician-card"
         data-specialization="Plumbing"
         data-rating="4.6"
         data-availability="Today"
         data-servicearea="Colombo">
      <img src="${pageContext.request.contextPath}/assets/images/pictures/tech_profile.jpg" alt="Technician">
      <div class="technician-details">
        <h3>David Silva <img src="${pageContext.request.contextPath}/assets/images/icons/verify.png" alt="verify"></h3>
        <p>Rating: 4.6 (25 reviews)</p>
        <p>Plumbing</p>
        <button onclick="viewDetails('technician_david.html')">View Details</button>
      </div>
    </div>
  </div>
</div>

<!-- JavaScript -->
<script>
  // Combined Search + Filter function
  function filterTechnicians() {
    const searchBox = document.getElementById('searchInput');
    const searchTerm = searchBox ? searchBox.value.toLowerCase() : "";

    const specialization = document.getElementById('specializationFilter').value.toLowerCase();
    const ratings = parseFloat(document.getElementById('ratingsFilter').value) || 0;
    const availability = document.getElementById('availabilityFilter').value.toLowerCase();
    const serviceArea = document.getElementById('serviceAreaFilter').value.toLowerCase();

    const cards = document.querySelectorAll('.technician-card');

    cards.forEach(card => {
      const name = card.querySelector('h3').innerText.toLowerCase();
      const specializationText = card.dataset.specialization.toLowerCase();
      const cardRating = parseFloat(card.dataset.rating);
      const cardAvailability = card.dataset.availability.toLowerCase();
      const cardServiceArea = card.dataset.servicearea.toLowerCase();

      let show = true;

      // Search check
      if (searchTerm && !name.includes(searchTerm) && !specializationText.includes(searchTerm)) {
        show = false;
      }

      // Specialization filter
      if (specialization && !specializationText.includes(specialization)) {
        show = false;
      }

      // Ratings filter
      if (ratings && cardRating < ratings) {
        show = false;
      }

      // Availability filter
      if (availability && cardAvailability !== availability) {
        show = false;
      }

      // Service area filter
      if (serviceArea && cardServiceArea !== serviceArea) {
        show = false;
      }

      card.style.display = show ? 'flex' : 'none';
    });
  }

  // View Details redirect
  function viewDetails(pageUrl) {
    window.location.href = pageUrl;
  }
</script>

</body>
</html>