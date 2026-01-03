<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <%@ page import="com.dailyfixer.model.User" %>

            <% User user=(User) session.getAttribute("currentUser"); if (user==null ||
                !"volunteer".equals(user.getRole())) { response.sendRedirect(request.getContextPath()
                + "/pages/shared/login.jsp" ); return; } %>

                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Volunteer Dashboard | Daily Fixer</title>
                    <link
                        href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&family=Inter:wght@400;500;600;700&family=Lora:wght@400;500;600;700&family=IBM+Plex+Mono:wght@400;500;600&display=swap"
                        rel="stylesheet">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/framework.css">
                    <style>
                        .container {
                            flex: 1;
                            margin-left: 240px;
                            margin-top: 83px;
                            padding: 30px;
                            background-color: var(--background);
                        }

                        .container h2 {
                            font-size: 1.6em;
                            margin-bottom: 20px;
                            color: var(--foreground);
                        }

                        .volunteer-stats {
                            background: var(--card);
                            padding: 25px;
                            border-radius: var(--radius-lg);
                            box-shadow: var(--shadow-lg);
                            border: 1px solid var(--border);
                            margin-bottom: 30px;
                        }

                        .volunteer-stats h3 {
                            font-size: 1.3em;
                            margin-bottom: 20px;
                            color: var(--foreground);
                            border-bottom: 2px solid var(--border);
                            padding-bottom: 10px;
                        }

                        .stats-grid {
                            display: grid;
                            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                            gap: 15px;
                        }

                        .info-box {
                            background: var(--muted);
                            padding: 15px;
                            border-radius: var(--radius-md);
                            border-left: 4px solid var(--primary);
                        }

                        .info-box p {
                            margin: 0;
                            color: var(--foreground);
                            font-weight: 500;
                        }
                    </style>
                </head>

                <body>

                    <header class="topbar">
                        <div class="logo">Daily Fixer</div>
                        <div class="panel-name">Volunteer Panel</div>
                        <div style="display: flex; align-items: center; gap: 10px;">
                            <button id="theme-toggle-btn" class="theme-toggle" onclick="toggleTheme()"
                                aria-label="Toggle dark mode">🌙 Dark</button>
                            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Log Out</a>
                        </div>
                    </header>

                    <aside class="sidebar">
                        <h3>Navigation</h3>
                        <ul>
                            <li><a href="${pageContext.request.contextPath}/pages/dashboards/volunteerdash/volunteerdashmain.jsp"
                                    class="active">Dashboard</a></li>
                            <li><a href="${pageContext.request.contextPath}/pages/guides/my-guides.jsp">My Guides</a>
                            </li>
                            <li><a href="${pageContext.request.contextPath}/guides/create">Create Guide</a></li>
                            <li><a href="${pageContext.request.contextPath}/guides">View All Guides</a></li>
                            <li><a
                                    href="${pageContext.request.contextPath}/pages/dashboards/volunteerdash/myProfile.jsp">My
                                    Profile</a></li>
                        </ul>
                    </aside>

                    <main class="container">
                        <h2>Dashboard</h2>

                        <div class="stats-container">
                            <div class="stat-card">
                                <p class="number">12</p>
                                <p>Most Popular Guide</p>
                            </div>
                            <div class="stat-card">
                                <p class="number">4.8</p>
                                <p>Average Guide Rating</p>
                            </div>
                            <div class="stat-card">
                                <p class="number">8</p>
                                <p>Total Guides Written</p>
                            </div>
                        </div>

                        <!-- Volunteer Stats -->
                        <div class="volunteer-stats">
                            <h3>Volunteer Stats</h3>
                            <div class="stats-grid">
                                <div class="info-box">
                                    <p><strong>Total Guides:</strong> 8</p>
                                </div>
                                <div class="info-box">
                                    <p><strong>Volunteer Rating:</strong> 4.8/5</p>
                                </div>
                                <div class="info-box">
                                    <p><strong>This Month:</strong> 3 guides</p>
                                </div>
                            </div>
                        </div>
                    </main>

                    <script src="${pageContext.request.contextPath}/assets/js/dark-mode.js"></script>

                </body>

                </html>