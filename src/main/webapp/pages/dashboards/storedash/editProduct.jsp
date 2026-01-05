<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ page import="com.dailyfixer.model.*" %>
        <%@ page import="java.util.*" %>
            <% User user=(User) session.getAttribute("currentUser"); if (user==null || !"store".equals(user.getRole()))
                { response.sendRedirect(request.getContextPath() + "/login.jsp" ); return; } Product p=(Product)
                request.getAttribute("product"); List<ProductVariation> variations = (List<ProductVariation>)
                    request.getAttribute("variations");

                    if(p == null) {
                    response.sendRedirect(request.getContextPath() + "/ListProductsServlet");
                    return;
                    }

                    String currentMain = p.getCategoryMain();
                    String currentSub = p.getCategorySub();
                    String categoryOtherStyle = "Other".equals(p.getCategorySub()) ? "display:block;" : "display:none;";
                    String currentOtherVal = (p.getCategoryOther() != null) ? p.getCategoryOther() : "";
                    %>
                    <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Edit Product | Daily Fixer</title>
                        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/framework.css">
                        <style>
                            .dashboard-container {
                                display: flex;
                                min-height: 100vh;
                            }

                            .main-content {
                                padding: 30px;
                                background-color: var(--background);
                                margin-top: 76px;
                                margin-left: 240px;
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

                            .remove-btn {
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

                        <header class="topbar">
                            <div class="logo">Daily Fixer</div>
                            <div class="panel-name">Store Panel</div>
                            <div><a href="${pageContext.request.contextPath}/logout" class="logout-btn">Log Out</a>
                            </div>
                        </header>
                        <aside class="sidebar">
                            <h3>Navigation</h3>
                            <ul>
                                <li><a
                                        href="${pageContext.request.contextPath}/pages/dashboards/storedash/storedashmain.jsp">Dashboard</a>
                                </li>
                                <li><a href="${pageContext.request.contextPath}/ListProductsServlet"
                                        class="active">Catalogue</a></li>
                            </ul>
                        </aside>

                        <main class="main-content">
                            <div class="form-container">
                                <h2>Edit Product</h2>
                                <p style="margin-bottom:20px; color:var(--muted-foreground);">Update product details.
                                    Note that changing variations will reset stock for new units.</p>

                                <% if(request.getAttribute("errorMessage") !=null) { %>
                                    <div class="error-message">
                                        <%= request.getAttribute("errorMessage") %>
                                    </div>
                                    <% } %>

                                        <form action="${pageContext.request.contextPath}/EditProductServlet"
                                            method="post" enctype="multipart/form-data">
                                            <input type="hidden" name="productId" value="<%=p.getProductId()%>">

                                            <!-- 1. Core Details -->
                                            <div class="section-title">Core Details</div>

                                            <div class="form-group">
                                                <label>Product Name *</label>
                                                <input type="text" name="name" value="<%=p.getName()%>" required>
                                            </div>

                                            <div class="form-group">
                                                <label>Brand *</label>
                                                <input type="text" name="brand" value="<%=p.getBrand()%>" required>
                                            </div>

                                            <div class="form-group">
                                                <label>Base Price (Rs.) *</label>
                                                <input type="number" step="0.01" name="basePrice"
                                                    value="<%=p.getBasePrice()%>" required>
                                            </div>

                                            <div class="form-group">
                                                <label>Stock Status</label>
                                                <select class="filter-select" name="stockStatus">
                                                    <option value="ACTIVE" <%="ACTIVE"
                                                        .equals(p.getStockStatus())?"selected":"" %>>Active</option>
                                                    <option value="OUT_OF_STOCK" <%="OUT_OF_STOCK"
                                                        .equals(p.getStockStatus())?"selected":"" %>>Out of Stock
                                                    </option>
                                                    <option value="DISCONTINUED" <%="DISCONTINUED"
                                                        .equals(p.getStockStatus())?"selected":"" %>>Discontinued
                                                    </option>
                                                </select>
                                            </div>

                                            <div class="form-group">
                                                <label>Description</label>
                                                <textarea name="description"><%=p.getDescription()%></textarea>
                                            </div>

                                            <div class="form-group">
                                                <label>Warranty Info</label>
                                                <input type="text" name="warrantyInfo" value="<%=p.getWarrantyInfo()%>">
                                            </div>

                                            <!-- Categories -->
                                            <div class="dynamic-row">
                                                <div class="form-group" style="flex:1">
                                                    <label>Main Category *</label>
                                                    <select class="filter-select" name="categoryMain" id="mainCat"
                                                        onchange="updateSubCats()" required>
                                                        <option value="">-- Select --</option>
                                                        <option value="Home Repair">Home Repair</option>
                                                        <option value="Home Electronic Repair">Home Electronic Repair
                                                        </option>
                                                        <option value="Vehicle Repair">Vehicle Repair</option>
                                                    </select>
                                                </div>
                                                <div class="form-group" style="flex:1">
                                                    <label>Sub Category *</label>
                                                    <select class="filter-select" name="categorySub" id="subCat"
                                                        onchange="checkOther(this)" required>
                                                        <option value="<%=p.getCategorySub()%>" selected>
                                                            <%=p.getCategorySub()%>
                                                        </option>
                                                    </select>
                                                </div>
                                            </div>

                                            <div class="form-group" id="otherCatContainer"
                                                style="<%=categoryOtherStyle%>">
                                                <label>Specify 'Other' Category</label>
                                                <input type="text" name="categoryOther" value="<%=currentOtherVal%>">
                                            </div>

                                            <div class="form-group">
                                                <label>Update Image (Leave blank to keep current)</label>
                                                <input type="file" name="image" accept="image/*">
                                                <% if(p.getImages() !=null && !p.getImages().isEmpty()) { %>
                                                    <p style="font-size:0.8rem; margin-top:5px;">Current: <a
                                                            href="${pageContext.request.contextPath}/<%=p.getImages().get(0).getImagePath()%>"
                                                            target="_blank">View Image</a></p>
                                                    <% } %>
                                            </div>

                                            <!-- 2. Dynamic Attributes -->
                                            <div class="section-title">Specification Attributes</div>
                                            <div id="attributes-list">
                                                <% if(p.getAttributes() !=null) { for(ProductAttribute pa :
                                                    p.getAttributes()) { %>
                                                    <div class="dynamic-row">
                                                        <input type="text" name="attrNames"
                                                            value="<%=pa.getAttrName()%>" required>
                                                        <input type="text" name="attrValues"
                                                            value="<%=pa.getAttrValue()%>" required>
                                                        <button type="button" class="remove-btn"
                                                            onclick="this.parentElement.remove()">X</button>
                                                    </div>
                                                    <% } } %>
                                            </div>
                                            <button type="button" class="btn-secondary" onclick="addAttributeRow()">+
                                                Add Attribute</button>


                                            <!-- 3. Variations -->
                                            <div class="section-title">Product Variations</div>
                                            <p class="help-text">Modify groups and re-generate to update pricing.</p>

                                            <div id="variation-groups-list">
                                                <% int groupIdx=0; if(p.getVariationGroups() !=null) {
                                                    for(VariationGroup vg : p.getVariationGroups()) { String optsStr=""
                                                    ; if(vg.getOptions() !=null) { StringBuilder sb=new StringBuilder();
                                                    for(int k=0; k<vg.getOptions().size(); k++) {
                                                    sb.append(vg.getOptions().get(k).getOptionValue()); if(k <
                                                    vg.getOptions().size()-1) sb.append(", ");
                               }
                               optsStr = sb.toString();
                           }
                %>
                   <div class=" dynamic-row" style="background:var(--muted); padding:10px; border-radius:var(--radius-md);">
                                                    <div style="flex:1">
                                                        <label style="font-size:0.8rem; font-weight:600;">Group
                                                            Name</label>
                                                        <input type="text" name="groupName_<%=groupIdx%>"
                                                            class="grp-name" value="<%=vg.getGroupName()%>">
                                                    </div>
                                                    <div style="flex:2">
                                                        <label
                                                            style="font-size:0.8rem; font-weight:600;">Options</label>
                                                        <input type="text" name="groupOptions_<%=groupIdx%>"
                                                            class="grp-opts" value="<%=optsStr%>">
                                                    </div>
                                                    <button type="button" class="remove-btn"
                                                        onclick="this.parentElement.remove()"
                                                        style="margin-top:20px;">X</button>
                                            </div>
                                            <% groupIdx++; } } %>
                            </div>

                            <button type="button" class="btn-secondary" onclick="addVariationGroup()">+ Add Variation
                                Group</button>
                            <button type="button" class="btn-primary" onclick="generateVariations()"
                                style="margin-left:10px;">Re-Generate Combinations</button>
                            <input type="hidden" name="groupCount" id="groupCount" value="<%=groupIdx%>">

                            <div id="variations-output" style="display:block; margin-top:20px;">
                                <h4 style="margin-bottom:10px;">Variation Combinations</h4>
                                <p class="help-text">Click "Re-Generate" to refresh this list based on groups above.</p>
                                <div class="variation-table-container">
                                    <table class="variation-table">
                                        <thead>
                                            <tr>
                                                <th>Combination</th>
                                                <th>SKU</th>
                                                <th>Price</th>
                                                <th>Stock</th>
                                            </tr>
                                        </thead>
                                        <tbody id="variations-tbody">
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <div class="form-actions">
                                <button type="submit" class="btn-primary">Update Product</button>
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
                                const currentSubVal = "<%=currentSub%>";

                                sub.innerHTML = '<option value="">-- Select --</option>';
                                if (subCats[main]) {
                                    subCats[main].forEach(c => {
                                        const opt = document.createElement("option");
                                        opt.value = c;
                                        opt.innerText = c;
                                        if (c === currentSubVal) opt.selected = true;
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

                            // Init categories
                            document.getElementById("mainCat").value = "<%=currentMain%>";
                            updateSubCats(); // Will select sub if matches

                            // --- Attribute Logic ---
                            function addAttributeRow() {
                                const div = document.createElement("div");
                                div.className = "dynamic-row";
                                div.innerHTML = `
            <input type="text" name="attrNames" placeholder="Name" required>
            <input type="text" name="attrValues" placeholder="Value" required>
            <button type="button" class="remove-btn" onclick="this.parentElement.remove()">X</button>
        `;
                                document.getElementById("attributes-list").appendChild(div);
                            }

                            // --- Variation Logic ---
                            let groupCounter = <%=groupIdx%>;

                            function addVariationGroup() {
                                const div = document.createElement("div");
                                div.className = "dynamic-row";
                                div.style.background = "var(--muted)";
                                div.style.padding = "10px";
                                div.style.borderRadius = "var(--radius-md)";

                                // We carefully construct string to avoid JS syntax errors with unescaped HTML inside JS
                                let html = '';
                                html += '<div style="flex:1">';
                                html += '   <label style="font-size:0.8rem; font-weight:600;">Group Name</label>';
                                html += '   <input type="text" name="groupName_' + groupCounter + '" class="grp-name" placeholder="e.g. Color">';
                                html += '</div>';
                                html += '<div style="flex:2">';
                                html += '   <label style="font-size:0.8rem; font-weight:600;">Options</label>';
                                html += '   <input type="text" name="groupOptions_' + groupCounter + '" class="grp-opts" placeholder="e.g. Red, Blue">';
                                html += '</div>';
                                html += '<button type="button" class="remove-btn" onclick="this.parentElement.remove()" style="margin-top:20px;">X</button>';

                                div.innerHTML = html;

                                document.getElementById("variation-groups-list").appendChild(div);
                                groupCounter++;
                                document.getElementById("groupCount").value = groupCounter;
                            }

                            function generateVariations() {
                                const container = document.getElementById("variation-groups-list");
                                const rows = container.getElementsByClassName("dynamic-row");

                                let groups = [];
                                for (let row of rows) {
                                    const nameEl = row.querySelector(".grp-name");
                                    const optsEl = row.querySelector(".grp-opts");
                                    if (nameEl && optsEl) {
                                        const name = nameEl.value.trim();
                                        const optsStr = optsEl.value;
                                        if (name && optsStr) {
                                            const opts = optsStr.split(",").map(s => s.trim()).filter(s => s !== "");
                                            if (opts.length > 0) {
                                                groups.push({ name: name, options: opts });
                                            }
                                        }
                                    }
                                }

                                if (groups.length === 0) {
                                    // alert("No variation groups detected."); // Optional alert
                                    return;
                                }

                                const combinations = cartesian(groups.map(g => g.options));
                                const tbody = document.getElementById("variations-tbody");
                                tbody.innerHTML = "";

                                combinations.forEach((combo, idx) => {
                                    const comboStr = combo.join(", ");
                                    const mappingStr = combo.join(",");

                                    const tr = document.createElement("tr");
                                    let rowHtml = '';
                                    rowHtml += '<td>';
                                    rowHtml += '    <strong>' + comboStr + '</strong>';
                                    rowHtml += '    <input type="hidden" name="varMapping" value="' + mappingStr + '">';
                                    rowHtml += '</td>';
                                    rowHtml += '<td><input type="text" name="varSku" placeholder="SKU-' + (idx + 1) + '"></td>';
                                    rowHtml += '<td><input type="number" step="0.01" name="varPrice" placeholder="Override Base"></td>';
                                    rowHtml += '<td><input type="number" name="varStock" value="0"></td>';

                                    tr.innerHTML = rowHtml;
                                    tbody.appendChild(tr);
                                });
                                document.getElementById("variations-output").style.display = "block";
                            }

                            function cartesian(arrays) {
                                return arrays.reduce((a, b) => a.flatMap(d => b.map(e => [d, e].flat())), [[]]);
                            }

                            window.addEventListener('load', () => {
                                // Only generate if groups exist
                                if (document.getElementsByClassName("grp-name").length > 0) {
                                    generateVariations();
                                }
                            });
                        </script>

                    </body>

                    </html>