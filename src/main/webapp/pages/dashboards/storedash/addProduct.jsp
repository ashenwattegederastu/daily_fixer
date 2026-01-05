<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ page import="com.dailyfixer.model.User" %>
        <% User user=(User) session.getAttribute("currentUser"); if (user==null || !"store".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp" ); return; } %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Add Product | Daily Fixer</title>
                <!-- Using the framework CSS as requested -->
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/framework.css">
                <!-- Simple Google Font import if not in framework -->
                <link
                    href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap"
                    rel="stylesheet">
                <style>
                    /* Page specific overrides or helpers */
                    .dashboard-container {
                        display: flex;
                        min-height: 100vh;
                    }

                    .main-content {
                        padding: 30px;
                        background-color: var(--background);
                        margin-top: 76px;
                        /* Topbar height */
                        margin-left: 240px;
                        /* Sidebar width */
                        flex: 1;
                    }

                    .section-title {
                        font-size: 1.1rem;
                        font-weight: 700;
                        margin-bottom: 15px;
                        color: var(--primary);
                        border-bottom: 2px solid var(--border);
                        padding-bottom: 5px;
                        margin-top: 20px;
                    }

                    .dynamic-row {
                        display: flex;
                        gap: 15px;
                        margin-bottom: 10px;
                        align-items: center;
                    }

                    .dynamic-row input {
                        flex: 1;
                    }

                    .dynamic-row .remove-btn {
                        background: var(--destructive);
                        color: white;
                        border: none;
                        padding: 8px 12px;
                        border-radius: var(--radius-md);
                        cursor: pointer;
                    }

                    .variation-table-container {
                        overflow-x: auto;
                        margin-top: 15px;
                        border: 1px solid var(--border);
                        border-radius: var(--radius-md);
                    }

                    .variation-table {
                        width: 100%;
                        border-collapse: collapse;
                    }

                    .variation-table th,
                    .variation-table td {
                        padding: 10px;
                        text-align: left;
                        border-bottom: 1px solid var(--border);
                    }

                    .variation-table th {
                        background: var(--muted);
                        font-weight: 600;
                    }

                    .variation-table input {
                        width: 100%;
                        padding: 6px;
                    }

                    .help-text {
                        font-size: 0.85rem;
                        color: var(--muted-foreground);
                        margin-bottom: 10px;
                    }
                </style>
            </head>

            <body>

                <!-- Topbar -->
                <header class="topbar">
                    <div class="logo">Daily Fixer</div>
                    <div class="panel-name">Store Panel</div>
                    <div>
                        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Log Out</a>
                    </div>
                </header>

                <!-- Sidebar -->
                <aside class="sidebar">
                    <h3>Navigation</h3>
                    <ul>
                        <li><a
                                href="${pageContext.request.contextPath}/pages/dashboards/storedash/storedashmain.jsp">Dashboard</a>
                        </li>
                        <li><a
                                href="${pageContext.request.contextPath}/pages/dashboards/storedash/orders.jsp">Orders</a>
                        </li>
                        <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/upfordelivery.jsp">Up
                                for Delivery</a></li>
                        <li><a href="${pageContext.request.contextPath}/pages/dashboards/storedash/completedorders.jsp">Completed
                                Orders</a></li>
                        <li><a href="${pageContext.request.contextPath}/ListProductsServlet"
                                class="active">Catalogue</a></li>
                        <li><a
                                href="${pageContext.request.contextPath}/pages/dashboards/storedash/myProfile.jsp">Profile</a>
                        </li>
                    </ul>
                </aside>

                <main class="main-content">
                    <div class="form-container">
                        <h2>Add New Product</h2>
                        <p style="margin-bottom:20px; color:var(--muted-foreground);">Create a detailed product listing
                            with attributes and variations.</p>

                        <% if(request.getAttribute("errorMessage") !=null) { %>
                            <div class="error-message">
                                <%= request.getAttribute("errorMessage") %>
                            </div>
                            <% } %>

                                <form action="${pageContext.request.contextPath}/AddProductServlet" method="post"
                                    enctype="multipart/form-data" id="addProductForm">

                                    <!-- 1. Core Details -->
                                    <div class="section-title">Core Details</div>

                                    <div class="form-group">
                                        <label>Product Name *</label>
                                        <input type="text" name="name" required placeholder="e.g. Premium Paint Bucket">
                                    </div>

                                    <div class="form-group">
                                        <label>Brand *</label>
                                        <input type="text" name="brand" required
                                            placeholder="e.g. Deluxe, Asian Paints">
                                    </div>

                                    <div class="form-group">
                                        <label>Base Price (Rs.) *</label>
                                        <input type="number" step="0.01" name="basePrice" required placeholder="0.00">
                                        <p class="help-text">This is the default price shown in listings.</p>
                                    </div>

                                    <div class="form-group">
                                        <label>Description</label>
                                        <textarea name="description" placeholder="Describe key features..."></textarea>
                                    </div>

                                    <div class="form-group">
                                        <label>Warranty Info</label>
                                        <input type="text" name="warrantyInfo"
                                            placeholder="e.g. 1 Year Manufacturer Warranty">
                                    </div>

                                    <!-- Categories -->
                                    <div class="dynamic-row">
                                        <div class="form-group" style="flex:1">
                                            <label>Main Category *</label>
                                            <select class="filter-select" name="categoryMain" id="mainCat"
                                                onchange="updateSubCats()" required>
                                                <option value="">-- Select --</option>
                                                <option value="Home Repair">Home Repair</option>
                                                <option value="Home Electronic Repair">Home Electronic Repair</option>
                                                <option value="Vehicle Repair">Vehicle Repair</option>
                                            </select>
                                        </div>
                                        <div class="form-group" style="flex:1">
                                            <label>Sub Category *</label>
                                            <select class="filter-select" name="categorySub" id="subCat"
                                                onchange="checkOther(this)" required>
                                                <option value="">-- Select Main First --</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="form-group" id="otherCatContainer" style="display:none;">
                                        <label>Specify 'Other' Category</label>
                                        <input type="text" name="categoryOther" placeholder="Enter custom category">
                                    </div>

                                    <div class="form-group">
                                        <label>Main Image *</label>
                                        <input type="file" name="image" accept="image/*" required>
                                    </div>

                                    <!-- 2. Dynamic Attributes -->
                                    <div class="section-title">Specification Attributes</div>
                                    <p class="help-text">Add detailed specs (e.g. Voltage: 220V, Material: Steel).</p>

                                    <div id="attributes-list">
                                        <!-- Dynamic rows appear here -->
                                    </div>
                                    <button type="button" class="btn-secondary" onclick="addAttributeRow()">+ Add
                                        Attribute</button>


                                    <!-- 3. Variations -->
                                    <div class="section-title">Product Variations</div>
                                    <p class="help-text">Define groups (e.g. Color, Size) to generate combinations.</p>

                                    <div id="variation-groups-list">
                                        <!-- Group rows appear here -->
                                    </div>

                                    <button type="button" class="btn-secondary" onclick="addVariationGroup()">+ Add
                                        Variation Group</button>
                                    <button type="button" class="btn-primary" onclick="generateVariations()"
                                        style="margin-left:10px;">Generate Combinations</button>

                                    <input type="hidden" name="groupCount" id="groupCount" value="0">

                                    <!-- Variations Table -->
                                    <div id="variations-output" style="display:none; margin-top:20px;">
                                        <h4 style="margin-bottom:10px;">Variation Combinations</h4>
                                        <div class="variation-table-container">
                                            <table class="variation-table">
                                                <thead>
                                                    <tr>
                                                        <th>Combination</th>
                                                        <th>SKU</th>
                                                        <th>Price Override</th>
                                                        <th>Stock</th>
                                                    </tr>
                                                </thead>
                                                <tbody id="variations-tbody">
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>

                                    <div class="form-actions">
                                        <button type="submit" class="btn-primary">Save Product</button>
                                        <a href="${pageContext.request.contextPath}/ListProductsServlet"
                                            class="btn-secondary">Cancel</a>
                                    </div>

                                </form>
                    </div>
                </main>

                <script>
                    // --- Category Logic ---
                    const subCats = {
                        "Home Repair": ["Plumbing", "Electrical (Basic)", "Carpentry", "Painting & Finishing", "Masonry", "Roofing", "Flooring", "Doors & Windows", "Other"],
                        "Home Electronic Repair": ["Mobile Devices", "Computers & Laptops", "Networking Devices", "Home Appliances", "Kitchen Electronics", "Entertainment Systems", "Power & Batteries", "Other"],
                        "Vehicle Repair": ["Engine & Mechanical", "Electrical Systems", "Braking System", "Suspension & Steering", "Transmission", "Cooling System", "Tyres & Wheels", "Body & Paint", "Other"]
                    };

                    function updateSubCats() {
                        const main = document.getElementById("mainCat").value;
                        const sub = document.getElementById("subCat");
                        sub.innerHTML = '<option value="">-- Select --</option>';
                        if (subCats[main]) {
                            subCats[main].forEach(c => {
                                const opt = document.createElement("option");
                                opt.value = c;
                                opt.innerText = c;
                                sub.appendChild(opt);
                            });
                        }
                    }

                    function checkOther(sel) {
                        const otherDiv = document.getElementById("otherCatContainer");
                        if (sel.value === "Other") {
                            otherDiv.style.display = "block";
                        } else {
                            otherDiv.style.display = "none";
                        }
                    }

                    // --- Attribute Logic ---
                    function addAttributeRow() {
                        const div = document.createElement("div");
                        div.className = "dynamic-row";
                        div.innerHTML = `
            <input type="text" name="attrNames" placeholder="Name (e.g. Material)" required>
            <input type="text" name="attrValues" placeholder="Value (e.g. Wood)" required>
            <button type="button" class="remove-btn" onclick="this.parentElement.remove()">X</button>
        `;
                        document.getElementById("attributes-list").appendChild(div);
                    }

                    // --- Variation Logic ---
                    let groupCounter = 0;

                    function addVariationGroup() {
                        const div = document.createElement("div");
                        div.className = "dynamic-row";
                        div.style.background = "var(--muted)";
                        div.style.padding = "10px";
                        div.style.borderRadius = "var(--radius-md)";

                        div.innerHTML = `
            <div style="flex:1">
                <label style="font-size:0.8rem; font-weight:600;">Group Name</label>
                <input type="text" name="groupName_${groupCounter}" class="grp-name" placeholder="e.g. Color">
            </div>
            <div style="flex:2">
                <label style="font-size:0.8rem; font-weight:600;">Options (comma separated)</label>
                <input type="text" name="groupOptions_${groupCounter}" class="grp-opts" placeholder="e.g. Red, Blue, Green">
            </div>
            <button type="button" class="remove-btn" onclick="this.parentElement.remove()" style="margin-top:20px;">X</button>
        `;

                        document.getElementById("variation-groups-list").appendChild(div);
                        groupCounter++;
                        document.getElementById("groupCount").value = groupCounter;
                    }

                    function generateVariations() {
                        const container = document.getElementById("variation-groups-list");
                        const rows = container.getElementsByClassName("dynamic-row");

                        let groups = [];
                        for (let row of rows) {
                            const name = row.querySelector(".grp-name").value.trim();
                            const optsStr = row.querySelector(".grp-opts").value;
                            if (name && optsStr) {
                                const opts = optsStr.split(",").map(s => s.trim()).filter(s => s !== "");
                                if (opts.length > 0) {
                                    groups.push({ name: name, options: opts });
                                }
                            }
                        }

                        if (groups.length === 0) {
                            alert("Please add at least one variation group with options first.");
                            return;
                        }

                        // Cartesian Product
                        const combinations = cartesian(groups.map(g => g.options));

                        const tbody = document.getElementById("variations-tbody");
                        tbody.innerHTML = "";

                        combinations.forEach((combo, idx) => {
                            // Combo is array of option strings corresponding to groups
                            // e.g. ["Red", "Small"]
                            const comboStr = combo.join(", "); // Display text
                            // const mappingStr = combo.map((val, i) => groups[i].name + ":" + val).join(";"); 
                            // Simplified mapping for Servlet: just comma separated values in order of groups
                            const mappingStr = combo.join(","); // "Red,Small"

                            const tr = document.createElement("tr");
                            tr.innerHTML = `
                <td>
                    <strong>${comboStr}</strong>
                    <input type="hidden" name="varMapping" value="${mappingStr}">
                </td>
                <td><input type="text" name="varSku" placeholder="SKU-${idx + 1}"></td>
                <td><input type="number" step="0.01" name="varPrice" placeholder="Override Base Price"></td>
                <td><input type="number" name="varStock" value="0"></td>
            `;
                            tbody.appendChild(tr);
                        });

                        document.getElementById("variations-output").style.display = "block";
                    }

                    // Helper for Cartesian product of arrays
                    function cartesian(arrays) {
                        return arrays.reduce((a, b) => a.flatMap(d => b.map(e => [d, e].flat())), [[]]);
                    }
                </script>

            </body>

            </html>