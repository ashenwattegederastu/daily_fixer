<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>

        <style>
            /* Overlay for Mobile - Not in framework.css */
            .dash-overlay {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: rgba(0, 0, 0, 0.5);
                z-index: 1000;
                /* High z-index to cover content */
                display: none;
                opacity: 0;
                transition: opacity 0.3s ease;
            }

            .dash-overlay.active {
                display: block;
                opacity: 1;
            }

            /* Ensure sidebar is above overlay on mobile only */
            @media (max-width: 768px) {
                .sidebar {
                    z-index: 1001 !important;
                    /* Higher than overlay */
                }
            }
        </style>

        <!-- Overlay for closing sidebar on mobile -->
        <div class="dash-overlay" id="dash-overlay"></div>

        <aside class="sidebar" id="dash-sidebar">
            <ul>
                <li>
                    <a href="${pageContext.request.contextPath}/pages/dashboards/userdash/userdashmain.jsp"
                        class="${pageContext.request.requestURI.endsWith('userdashmain.jsp') ? 'active' : ''}">
                        Dashboard
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/pages/dashboards/userdash/notifications.jsp"
                        class="${pageContext.request.requestURI.endsWith('notifications.jsp') ? 'active' : ''}">
                        Notifications
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/pages/dashboards/userdash/myBookings.jsp"
                        class="${pageContext.request.requestURI.endsWith('myBookings.jsp') ? 'active' : ''}">
                        My Bookings
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/user/orders"
                        class="${pageContext.request.requestURI.endsWith('myPurchases.jsp') || pageContext.request.requestURI.contains('/user/orders') ? 'active' : ''}">
                        My Purchases
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/pages/dashboards/userdash/myProfile.jsp"
                        class="${pageContext.request.requestURI.endsWith('myProfile.jsp') ? 'active' : ''}">
                        My Profile
                    </a>
                </li>
            </ul>
        </aside>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const toggleBtn = document.getElementById('sidebar-toggle');
                const sidebar = document.getElementById('dash-sidebar');
                const overlay = document.getElementById('dash-overlay');

                if (toggleBtn) {
                    toggleBtn.addEventListener('click', function () {
                        sidebar.classList.toggle('open');
                        this.classList.toggle('active'); // Animate hamburger
                        overlay.classList.toggle('active');
                    });
                }

                // Close sidebar when clicking overlay
                if (overlay) {
                    overlay.addEventListener('click', function () {
                        sidebar.classList.remove('open');
                        if (toggleBtn) toggleBtn.classList.remove('active');
                        overlay.classList.remove('active');
                    });
                }
            });
        </script>