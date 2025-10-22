<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daily Fixer</title>
    <!-- Link to external stylesheet -->
    <link rel="stylesheet" href="assets/css/diag.css">
</head>
<body>
<header>

    <!-- Main Navbar -->
    <nav class="navbar">
        <div class="logo">Daily Fixer</div>
        <ul class="nav-links">
            <li><a href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
            <li><a href="${pageContext.request.contextPath}/login.jsp">Log in</a></li>
        </ul>
    </nav>

    <!-- Rounded Subnav -->
    <div class="subnav">
        <a href="#" class="active">Diagnose Now</a>
        <a href="find_technician.html">Find a Technician</a>
        <a href="#">View Repair Guides</a>
        <a href="store.html">Stores</a>
    </div>
</header>

<main class="container">
    <h2 class="page-title">Diagnostics</h2>
    <div class="search-section">
        <h3 class="issue-title">What's the issue?</h3>
        <div class="search-box">
            <input type="text" placeholder="search for a issue">
            <button>
                <img src="images/search.png" alt="Search">
            </button>
        </div>
    </div>

    <div class="category">Electrical Repairs</div>
    <div class="problem-section">
        <div class="question-box" id="question0">
            Where is the problem occurring?
        </div>
        <div class="options-grid">
            <button class="option-btn">Home Wiring</button>
            <button class="option-btn">Switches</button>
            <button class="option-btn">Lights</button>
            <button class="option-btn">Iron</button>
            <button class="option-btn">TV</button>
            <button class="option-btn">Fridge</button>
            <button class="option-btn" data-next="question1">Fan</button>
            <button class="option-btn">Sockets</button>
            <button class="option-btn">Overheating</button>
            <button class="option-btn">Burning smell</button>
            <button class="option-btn">Shocks</button>
            <button class="option-btn">Cookers</button>
            <button class="option-btn">Washing Machine</button>
            <button class="option-btn">Blender</button>
            <button class="option-btn">Oven</button>
            <button class="option-btn">Plug point</button>
        </div>
    </div>

    <!-- Step 1 -->
    <div class="question-box" id="question1"  style="display:none;">
        <button class="prev-btn" data-prev="question0">Previous</button>
        Is the fan turning on when you switch it on?
    </div>
    <div class="options-grid centered" id="options1"  style="display:none;">
        <button class="option-btn" data-next="question4" data-answer="yes">Yes</button>
        <button class="option-btn" data-next="question2" data-answer="no">No</button>
    </div>

    <!-- Step 2 -->
    <div class="question-box" id="question2" style="display:none;">
        <button class="prev-btn" data-prev="question1">Previous</button>
        Is there power in the switchboard?
    </div>
    <div class="options-grid centered" id="options2" style="display:none;">
        <button class="option-btn" data-next="question3" data-answer="yes">Yes</button>
        <button class="option-btn" data-next="check_power" data-answer="no">No</button>
    </div>

    <!-- Step 3 -->
    <div class="question-box" id="question3" style="display:none;">
        <button class="prev-btn" data-prev="question2">Previous</button>
        Can you hear any humming sound from the fan?
    </div>
    <div class="options-grid centered" id="options3" style="display:none;">
        <button class="option-btn" data-next="question5" data-answer="yes">Yes</button>
        <button class="option-btn" data-next="wiring_fault" data-answer="no">No</button>
    </div>

    <!-- Step 4 -->
    <div class="question-box" id="question4" style="display:none;">
        <button class="prev-btn" data-prev="question3">Previous</button>
        Is the fan rotating slowly or unevenly?
    </div>
    <div class="options-grid centered" id="options4" style="display:none;">
        <button class="option-btn" data-next="question6" data-answer="yes">Yes</button>
        <button class="option-btn" data-next="question7" data-answer="no">No</button>
    </div>

    <!-- Suggestion pages -->
    <div class="suggestion-page" id="question5" style="display:none;">
        <h2>Diagnostic Results for Your Fan</h2>

        <div class="top-section">
            <div class="most-likely-issue card">
                <h3>Most Likely Issue</h3>
                <p><strong>Fan capacitor fault</strong></p>
                <p>The capacitor inside the fan is worn out or damaged, causing the fan to not start or run slowly.</p>
                <p>Confidence level</p>
                <div class="confidence-bar">
                    <div class="confidence-level" style="width: 75%;"></div>
                </div>
                <button class="book-btn" onclick="window.location.href='find_technician.html'">Book Technician</button>

            </div>

            <div class="recommended-fixes card">
                <h3>Recommended Fixes</h3>
                <ul>
                    <li>Test the capacitor using a multimeter and replace if faulty.</li>
                    <li>Ensure all connections to the capacitor are secure.</li>
                    <li>Restart the fan and check for normal operation.</li>
                </ul>
            </div>
        </div>

        <div class="repair-guides card">
            <h3>Recommended Repair Guides</h3>
            <ul>
                <li onclick="window.open('guide1.html', '_blank')">How to Test a Ceiling Fan Capacitor</li>
                <li onclick="window.open('guide2.html', '_blank')">Troubleshooting Ceiling Fan</li>
                <li onclick="window.open('guide3.html', '_blank')">Routine Ceiling Fan Maintenance Guide</li>
            </ul>
        </div>

        <div class="parts-tools card">
            <h3>Recommended Parts and Tools</h3>
            <div class="parts-grid">
                <div class="part-item" onclick="alert('Blades selected!')">capacitor</div>
                <div class="part-item" onclick="alert('Fan Motor selected!')">Screwdriver set</div>
                <div class="part-item" onclick="alert('Bearings selected!')">Multimeter</div>
            </div>
        </div>
    </div>

    <div class="suggestion-page" id="question6" style="display:none;">
        <h2>Diagnostic Results for Your Fan</h2>

        <div class="top-section">
            <div class="most-likely-issue card">
                <h3>Most Likely Issue</h3>
                <p><strong>Dust Buildup or Worn Bearings</strong></p>
                <p>Dust or aging can cause friction in the fan motor, slowing rotation and reducing efficiency.</p>
                <p>Confidence level</p>
                <div class="confidence-bar">
                    <div class="confidence-level" style="width: 75%;"></div>
                </div>
                <button class="book-btn" onclick="window.location.href='find_technician.html'">Book Technician</button>

            </div>

            <div class="recommended-fixes card">
                <h3>Recommended Fixes</h3>
                <ul>
                    <li>Clean the fan blades and motor vents using a soft brush or compressed air.</li>
                    <li>Apply a few drops of machine oil to the motor shaft if accessible.</li>
                    <li>If noise or slow rotation continues, consider replacing the bearings or the motor unit.</li>
                </ul>
            </div>
        </div>

        <div class="repair-guides card">
            <h3>Recommended Repair Guides</h3>
            <ul>
                <li onclick="window.open('guide1.html', '_blank')">Cleaning a Ceiling Fan: Step-by-Step</li>
                <li onclick="window.open('guide2.html', '_blank')">Lubricating Ceiling Fan Bearings</li>
                <li onclick="window.open('guide3.html', '_blank')">Routine Ceiling Fan Maintenance Guide</li>
            </ul>
        </div>

        <div class="parts-tools card">
            <h3>Recommended Parts and Tools</h3>
            <div class="parts-grid">
                <div class="part-item" onclick="alert('Blades selected!')">Blades</div>
                <div class="part-item" onclick="alert('Fan Motor selected!')">Fan Motor</div>
                <div class="part-item" onclick="alert('Bearings selected!')">Bearings</div>
            </div>
        </div>
    </div>


    <div class="suggestion-box center-screen" id="question7" style="display:none;">
        <h3>Fan rotates fine</h3>
        <p>No repair needed.</p>
    </div>

    <div class="suggestion-page" id="check_power" style="display:none;">
        <h2>Diagnostic Results for Your Fan</h2>

        <div class="top-section">
            <div class="most-likely-issue card">
                <h3>Most Likely Issue</h3>
                <p><strong>Power not reaching the fan</strong></p>
                <p>The fan isn't receiving electricity, possibly due to a tripped breaker, blown fuse, or disconnected wiring.</p>
                <p>Confidence level</p>
                <div class="confidence-bar">
                    <div class="confidence-level" style="width: 75%;"></div>
                </div>
                <button class="book-btn" onclick="window.location.href='find_technician.html'">Book Technician</button>

            </div>

            <div class="recommended-fixes card">
                <h3>Recommended Fixes</h3>
                <ul>
                    <li>Check the main circuit breaker or fuse box and reset or replace if needed.</li>
                    <li>Inspect wiring connections in the switchboard for loose or damaged wires.</li>
                    <li>Ensure the wall switch controlling the fan is functional.</li>
                </ul>
            </div>
        </div>

        <div class="repair-guides card">
            <h3>Recommended Repair Guides</h3>
            <ul>
                <li onclick="window.open('guide1.html', '_blank')">How to Check Main Power Supply</li>
                <li onclick="window.open('guide2.html', '_blank')">Resetting a Tripped Circuit Breaker Safely</li>
                <li onclick="window.open('guide3.html', '_blank')">Inspecting Switchboard Wiring for Beginners</li>
            </ul>
        </div>

        <div class="parts-tools card">
            <h3>Recommended Parts and Tools</h3>
            <div class="parts-grid">
                <div class="part-item" onclick="alert('Blades selected!')">Multimeter</div>
                <div class="part-item" onclick="alert('Fan Motor selected!')">Screwdriver set</div>
                <div class="part-item" onclick="alert('Bearings selected!')">Electrical tape</div>
            </div>
        </div>
    </div>

    <div class="suggestion-page" id="wiring_fault" style="display:none;">
        <h2>Diagnostic Results for Your Fan</h2>

        <div class="top-section">
            <div class="most-likely-issue card">
                <h3>Most Likely Issue</h3>
                <p><strong>Wiring or switch fault</strong></p>
                <p>The fan is not receiving proper electrical connection due to damaged wires or a faulty switch.</p>
                <p>Confidence level</p>
                <div class="confidence-bar">
                    <div class="confidence-level" style="width: 75%;"></div>
                </div>
                <button class="book-btn" onclick="window.location.href='find_technician.html'">Book Technician</button>

            </div>

            <div class="recommended-fixes card">
                <h3>Recommended Fixes</h3>
                <ul>
                    <li>Inspect the wall switch controlling the fan and replace if faulty.</li>
                    <li>Check wiring connections in the fan circuit for loose, broken, or disconnected wires.</li>
                    <li>Replace any damaged wires or connectors.</li>
                </ul>
            </div>
        </div>

        <div class="repair-guides card">
            <h3>Recommended Repair Guides</h3>
            <ul>
                <li onclick="window.open('guide1.html', '_blank')">Basic Electrical Safety While Inspecting Wires</li>
                <li onclick="window.open('guide2.html', '_blank')">How to Replace a Faulty Wall Switch</li>
                <li onclick="window.open('guide3.html', '_blank')">Troubleshooting Ceiling Fan</li>
            </ul>
        </div>

        <div class="parts-tools card">
            <h3>Recommended Parts and Tools</h3>
            <div class="parts-grid">
                <div class="part-item" onclick="alert('Blades selected!')">switch</div>
                <div class="part-item" onclick="alert('Fan Motor selected!')">Screwdriver set</div>
                <div class="part-item" onclick="alert('Bearings selected!')">Multimeter</div>
            </div>
        </div>
    </div>
</main>
<script>

    const buttons = document.querySelectorAll('.option-btn');

    buttons.forEach(btn => {
        btn.addEventListener('click', () => {
            const nextId = btn.getAttribute('data-next');
            if (!nextId) return;

            // Hide current question and its options
            let currentGrid = btn.closest('.options-grid');
            let currentQuestion = currentGrid?.previousElementSibling;
            if (currentQuestion) currentQuestion.style.display = 'none';
            if (currentGrid) currentGrid.style.display = 'none';

            // Determine next question + its option container
            const nextQuestion = document.getElementById(nextId);
            const nextOptions = document.getElementById('options' + nextId.replace('question',''));

            // Show next question box
            if (nextQuestion) nextQuestion.style.display = 'block';

            // Show next options properly — flex if centered, grid otherwise
            if (nextOptions) {
                if (nextOptions.classList.contains('centered')) {
                    nextOptions.style.display = 'flex';
                } else {
                    nextOptions.style.display = 'grid';
                }
            }
        });
    });
    // Store all question boxes and their option grids
    const questionBoxes = document.querySelectorAll('.question-box');
    const optionGrids = document.querySelectorAll('.options-grid');

    // Track the current question
    let currentQuestion = document.getElementById('question0');
    let currentOptions = document.querySelector('.problem-section .options-grid');

    // Function to show a question
    function showQuestion(questionId) {
        // Hide current question and its options
        if (currentQuestion) currentQuestion.style.display = 'none';
        if (currentOptions) currentOptions.style.display = 'none';

        // Show the new question
        currentQuestion = document.getElementById(questionId);

        if (!currentQuestion) return;

        currentQuestion.style.display = 'block';

        // Decide which options to show
        if (questionId === 'question0') {
            currentOptions = document.querySelector('.problem-section .options-grid');
            if (currentOptions) currentOptions.style.display = 'grid';
        } else {
            currentOptions = document.getElementById('options' + questionId.replace('question', ''));
            if (currentOptions) {
                currentOptions.style.display = currentOptions.classList.contains('centered') ? 'flex' : 'grid';
            }
        }
    }

    // Handle next buttons
    document.querySelectorAll('.option-btn[data-next]').forEach(btn => {
        btn.addEventListener('click', () => {
            const nextId = btn.getAttribute('data-next');
            showQuestion(nextId);
        });
    });

    // Handle previous buttons
    document.querySelectorAll('.prev-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            const prevId = btn.getAttribute('data-prev');
            showQuestion(prevId);
        });
    });





</script>

</body>
</html>
