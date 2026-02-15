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

                                .status-refunded {
                                    background-color: #6c757d;
                                    color: white;
                                }

                                .cancel-btn {
                                    padding: 6px 14px;
                                    background-color: var(--destructive);
                                    color: var(--destructive-foreground);
                                    border: none;
                                    border-radius: var(--radius-md);
                                    font-size: 0.8em;
                                    font-weight: 600;
                                    cursor: pointer;
                                    transition: all 0.2s ease;
                                }

                                .cancel-btn:hover {
                                    opacity: 0.9;
                                    transform: scale(1.02);
                                }

                                .cancel-btn:disabled {
                                    opacity: 0.5;
                                    cursor: not-allowed;
                                    transform: none;
                                }

                                .cancel-timer {
                                    font-size: 0.75em;
                                    color: var(--muted-foreground);
                                    margin-top: 4px;
                                    text-align: right;
                                }

                                .refund-info {
                                    font-size: 0.8em;
                                    color: var(--muted-foreground);
                                    margin-top: 4px;
                                    font-style: italic;
                                }

                                /* Cancel Modal */
                                .modal-overlay {
                                    display: none;
                                    position: fixed;
                                    top: 0;
                                    left: 0;
                                    width: 100%;
                                    height: 100%;
                                    background: rgba(0, 0, 0, 0.5);
                                    z-index: 1000;
                                    justify-content: center;
                                    align-items: center;
                                }

                                .modal-content {
                                    background: var(--card);
                                    border: 1px solid var(--border);
                                    border-radius: var(--radius-lg);
                                    padding: 30px;
                                    max-width: 420px;
                                    width: 90%;
                                    box-shadow: var(--shadow-lg);
                                }

                                .modal-title {
                                    font-size: 1.2em;
                                    font-weight: 700;
                                    color: var(--foreground);
                                    margin-bottom: 12px;
                                }

                                .modal-text {
                                    color: var(--muted-foreground);
                                    margin-bottom: 20px;
                                    line-height: 1.5;
                                }

                                .modal-actions {
                                    display: flex;
                                    gap: 10px;
                                    justify-content: flex-end;
                                }

                                .modal-cancel-btn {
                                    padding: 8px 18px;
                                    background: var(--muted);
                                    color: var(--foreground);
                                    border: 1px solid var(--border);
                                    border-radius: var(--radius-md);
                                    cursor: pointer;
                                    font-weight: 600;
                                }

                                .modal-confirm-btn {
                                    padding: 8px 18px;
                                    background: var(--destructive);
                                    color: var(--destructive-foreground);
                                    border: none;
                                    border-radius: var(--radius-md);
                                    cursor: pointer;
                                    font-weight: 600;
                                }

                                .modal-confirm-btn:disabled {
                                    opacity: 0.5;
                                    cursor: not-allowed;
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
                                                        <div style="text-align: right;">
                                                            <c:set var="statusClass"
                                                                value="status-${fn:toLowerCase(fn:replace(order.status, ' ', '_'))}" />
                                                            <span class="status-badge ${statusClass}">${order.status}</span>

                                                            <%-- Cancel button: only for PAID/PROCESSING orders --%>
                                                            <c:if test="${order.status == 'PAID' || order.status == 'PROCESSING'}">
                                                                <div style="margin-top: 8px;">
                                                                    <button class="cancel-btn"
                                                                        data-order-id="${order.orderId}"
                                                                        data-created-at="${order.createdAt.time}"
                                                                        onclick="showCancelModal(this)">
                                                                        Cancel Order
                                                                    </button>
                                                                    <div class="cancel-timer" data-timer-for="${order.orderId}"></div>
                                                                </div>
                                                            </c:if>

                                                            <%-- Refund info for refunded orders --%>
                                                            <c:if test="${order.status == 'REFUNDED'}">
                                                                <div class="refund-info">
                                                                    <c:if test="${not empty order.refundReason}">
                                                                        Reason: ${order.refundReason}
                                                                    </c:if>
                                                                </div>
                                                            </c:if>
                                                        </div>
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

                            <!-- Cancel Order Confirmation Modal -->
                            <div class="modal-overlay" id="cancelModal">
                                <div class="modal-content">
                                    <div class="modal-title">Cancel Order</div>
                                    <div class="modal-text">
                                        Are you sure you want to cancel order <strong id="cancelOrderIdDisplay"></strong>?
                                        This will initiate a refund to your original payment method.
                                    </div>
                                    <div class="modal-actions">
                                        <button class="modal-cancel-btn" onclick="closeCancelModal()">Go Back</button>
                                        <button class="modal-confirm-btn" id="confirmCancelBtn" onclick="confirmCancel()">Yes, Cancel Order</button>
                                    </div>
                                </div>
                            </div>

                            <script src="${pageContext.request.contextPath}/assets/js/dark-mode.js"></script>

                            <script>
                                let cancelOrderId = null;

                                function showCancelModal(btn) {
                                    cancelOrderId = btn.getAttribute('data-order-id');
                                    const createdAt = parseInt(btn.getAttribute('data-created-at'));
                                    const now = Date.now();
                                    const oneHour = 60 * 60 * 1000;

                                    if ((now - createdAt) > oneHour) {
                                        alert('The 1-hour cancellation window has expired for this order.');
                                        btn.disabled = true;
                                        btn.textContent = 'Window Expired';
                                        return;
                                    }

                                    document.getElementById('cancelOrderIdDisplay').textContent = '#' + cancelOrderId;
                                    document.getElementById('cancelModal').style.display = 'flex';
                                }

                                function closeCancelModal() {
                                    document.getElementById('cancelModal').style.display = 'none';
                                    cancelOrderId = null;
                                }

                                function confirmCancel() {
                                    if (!cancelOrderId) return;

                                    const btn = document.getElementById('confirmCancelBtn');
                                    btn.disabled = true;
                                    btn.textContent = 'Processing...';

                                    fetch('${pageContext.request.contextPath}/refund', {
                                        method: 'POST',
                                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                        body: 'orderId=' + encodeURIComponent(cancelOrderId) + '&cancelledBy=user&reason=Customer%20requested%20cancellation'
                                    })
                                    .then(response => response.json())
                                    .then(data => {
                                        closeCancelModal();
                                        if (data.success) {
                                            alert('Order cancelled successfully! ' + (data.message || ''));
                                            location.reload();
                                        } else {
                                            alert('Cancel failed: ' + (data.message || 'Unknown error'));
                                            btn.disabled = false;
                                            btn.textContent = 'Yes, Cancel Order';
                                        }
                                    })
                                    .catch(err => {
                                        closeCancelModal();
                                        alert('Error: ' + err.message);
                                        btn.disabled = false;
                                        btn.textContent = 'Yes, Cancel Order';
                                    });
                                }

                                // Update countdown timers
                                function updateTimers() {
                                    document.querySelectorAll('.cancel-btn').forEach(btn => {
                                        const createdAt = parseInt(btn.getAttribute('data-created-at'));
                                        const orderId = btn.getAttribute('data-order-id');
                                        const oneHour = 60 * 60 * 1000;
                                        const remaining = oneHour - (Date.now() - createdAt);
                                        const timerEl = document.querySelector('[data-timer-for="' + orderId + '"]');

                                        if (remaining <= 0) {
                                            btn.disabled = true;
                                            btn.textContent = 'Window Expired';
                                            if (timerEl) timerEl.textContent = '';
                                        } else {
                                            const mins = Math.floor(remaining / 60000);
                                            const secs = Math.floor((remaining % 60000) / 1000);
                                            if (timerEl) {
                                                timerEl.textContent = mins + 'm ' + secs + 's remaining';
                                            }
                                        }
                                    });
                                }

                                // Run timer updates every second
                                updateTimers();
                                setInterval(updateTimers, 1000);

                                // Close modal on background click
                                document.getElementById('cancelModal').addEventListener('click', function(e) {
                                    if (e.target === this) closeCancelModal();
                                });
                            </script>

                        </body>

                        </html>