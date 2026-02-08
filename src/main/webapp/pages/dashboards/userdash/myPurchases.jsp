<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
            <%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
                <%@ page import="com.dailyfixer.model.User" %>

                    <% User user=(User) session.getAttribute("currentUser"); if (user==null || user.getRole()==null ||
                        !"user".equalsIgnoreCase(user.getRole().trim())) {
                        response.sendRedirect(request.getContextPath() + "/pages/shared/login.jsp" ); return; } %>

                        <!DOCTYPE html>
                        <html lang="en">

                        <head>
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <title>My Purchases | Daily Fixer</title>
                            <link
                                href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap"
                                rel="stylesheet">
                            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/framework.css">

                            <style>
                                /* Page Specific Styles using Framework Variables */
                                .orders-grid {
                                    display: grid;
                                    grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
                                    gap: 20px;
                                    margin-top: 20px;
                                }

                                .order-card {
                                    background-color: var(--card);
                                    border: 1px solid var(--border);
                                    border-radius: var(--radius-lg);
                                    overflow: hidden;
                                    transition: all 0.3s ease;
                                    box-shadow: var(--shadow-sm);
                                }

                                .order-card:hover {
                                    transform: translateY(-4px);
                                    box-shadow: var(--shadow-lg);
                                    border-color: var(--primary);
                                }

                                .order-header {
                                    background-color: var(--muted);
                                    padding: 15px 20px;
                                    display: flex;
                                    justify-content: space-between;
                                    align-items: center;
                                    border-bottom: 1px solid var(--border);
                                }

                                .order-id {
                                    font-weight: 700;
                                    color: var(--foreground);
                                    font-family: var(--font-mono);
                                }

                                .order-date {
                                    color: var(--muted-foreground);
                                    font-size: 0.9em;
                                }

                                .order-items {
                                    padding: 20px;
                                }

                                .product-item {
                                    display: flex;
                                    gap: 15px;
                                    padding: 12px;
                                    background-color: var(--background);
                                    border-radius: var(--radius-md);
                                    margin-bottom: 10px;
                                    border: 1px solid var(--border);
                                }

                                .product-item:last-child {
                                    margin-bottom: 0;
                                }

                                .product-image {
                                    width: 60px;
                                    height: 60px;
                                    border-radius: var(--radius-md);
                                    object-fit: cover;
                                    background-color: var(--muted);
                                    border: 1px solid var(--border);
                                }

                                .product-placeholder {
                                    width: 60px;
                                    height: 60px;
                                    border-radius: var(--radius-md);
                                    background-color: var(--muted);
                                    display: flex;
                                    align-items: center;
                                    justify-content: center;
                                    font-size: 1.5em;
                                    color: var(--muted-foreground);
                                    border: 1px solid var(--border);
                                }

                                .product-details {
                                    flex: 1;
                                    display: flex;
                                    flex-direction: column;
                                    justify-content: center;
                                }

                                .product-name {
                                    font-weight: 600;
                                    color: var(--foreground);
                                    margin-bottom: 4px;
                                    font-size: 0.95em;
                                }

                                .product-meta {
                                    display: flex;
                                    gap: 12px;
                                    color: var(--muted-foreground);
                                    font-size: 0.85em;
                                    align-items: center;
                                }

                                .product-qty {
                                    background-color: var(--muted);
                                    padding: 2px 8px;
                                    border-radius: 12px;
                                    font-weight: 600;
                                    font-size: 0.8em;
                                }

                                .product-price {
                                    font-weight: 600;
                                    color: var(--primary);
                                }

                                .order-footer {
                                    padding: 15px 20px;
                                    background-color: var(--card);
                                    /* Match card bg */
                                    border-top: 1px solid var(--border);
                                    display: flex;
                                    justify-content: space-between;
                                    align-items: center;
                                }

                                .order-total span {
                                    color: var(--muted-foreground);
                                    font-size: 0.9em;
                                }

                                .order-total strong {
                                    color: var(--foreground);
                                    font-weight: 700;
                                    font-size: 1.1em;
                                }

                                /* Status Badges - Mapping to Framework Colors */
                                .status-badge {
                                    padding: 4px 10px;
                                    border-radius: 20px;
                                    font-size: 0.75em;
                                    font-weight: 700;
                                    text-transform: uppercase;
                                }

                                .status-pending {
                                    background-color: var(--chart-3);
                                    /* Orange/Yellow */
                                    color: white;
                                }

                                .status-paid {
                                    background-color: var(--secondary);
                                    color: var(--secondary-foreground);
                                    border: 1px solid var(--border);
                                }

                                .status-processing {
                                    background-color: var(--primary);
                                    color: var(--primary-foreground);
                                }

                                .status-out_for_delivery {
                                    background-color: var(--accent);
                                    color: var(--accent-foreground);
                                }

                                .status-delivered {
                                    background-color: var(--chart-1);
                                    /* Green */
                                    color: white;
                                }

                                .status-cancelled {
                                    background-color: var(--destructive);
                                    color: var(--destructive-foreground);
                                }

                                /* Responsive adjustments */
                                @media (max-width: 768px) {
                                    .orders-grid {
                                        grid-template-columns: 1fr;
                                    }
                                }
                            </style>
                        </head>

                        <body>

                            <jsp:include page="header.jsp" />
                            <jsp:include page="sidebar.jsp" />

                            <main class="container">
                                <div class="dashboard-header">
                                    <h1>My Purchases</h1>
                                    <p>Track your orders and view purchase history</p>
                                </div>

                                <c:choose>
                                    <c:when test="${not empty orders}">
                                        <div class="orders-grid">
                                            <c:forEach var="order" items="${orders}">
                                                <div class="order-card">
                                                    <div class="order-header">
                                                        <span class="order-id">#${order.orderId}</span>
                                                        <span class="order-date">
                                                            <c:if test="${order.createdAt != null}">
                                                                <fmt:formatDate value="${order.createdAt}"
                                                                    pattern="MMM dd, yyyy" />
                                                            </c:if>
                                                        </span>
                                                    </div>

                                                    <div class="order-items">
                                                        <c:choose>
                                                            <c:when test="${not empty orderItemsMap[order.orderId]}">
                                                                <c:forEach var="item"
                                                                    items="${orderItemsMap[order.orderId]}">
                                                                    <div class="product-item">
                                                                        <c:choose>
                                                                            <c:when
                                                                                test="${not empty productsMap[item.productId] and not empty productsMap[item.productId].imageBase64}">
                                                                                <img src="data:image/jpeg;base64,${productsMap[item.productId].imageBase64}"
                                                                                    alt="${item.productName}"
                                                                                    class="product-image">
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <div class="product-placeholder">📦
                                                                                </div>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                        <div class="product-details">
                                                                            <div class="product-name">
                                                                                ${item.productName}</div>
                                                                            <div class="product-meta">
                                                                                <span
                                                                                    class="product-qty">x${item.quantity}</span>
                                                                                <span class="product-price">LKR
                                                                                    ${item.unitPrice}</span>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </c:forEach>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="product-item">
                                                                    <div class="product-placeholder">📦</div>
                                                                    <div class="product-details">
                                                                        <div class="product-name">${order.productName}
                                                                        </div>
                                                                        <div class="product-meta">
                                                                            <span
                                                                                class="product-price">${order.currency}
                                                                                ${order.formattedAmount}</span>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>

                                                    <div class="order-footer">
                                                        <div class="order-total">
                                                            <span>Total:</span>
                                                            <strong>${order.currency} ${order.formattedAmount}</strong>
                                                        </div>
                                                        <c:set var="statusClass"
                                                            value="status-${fn:toLowerCase(fn:replace(order.status, ' ', '_'))}" />
                                                        <span class="status-badge ${statusClass}">${order.status}</span>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="empty-state">
                                            <div class="empty-icon" style="font-size: 3rem; margin-bottom: 1rem;">🛒
                                            </div>
                                            <h3>No Orders Yet</h3>
                                            <p>You haven't made any purchases yet. Start exploring our stores to find
                                                amazing products!</p>
                                            <a href="${pageContext.request.contextPath}/stores" class="btn-primary"
                                                style="margin-top: 1rem;">Browse Stores</a>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </main>

                            <script src="${pageContext.request.contextPath}/assets/js/dark-mode.js"></script>

                        </body>

                        </html>