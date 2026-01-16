<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <%@ page
            import="com.dailyfixer.model.User,com.dailyfixer.model.VolunteerStats,com.dailyfixer.dao.VolunteerStatsDAO,com.dailyfixer.model.Guide,java.util.List"
            %>

            <% User user=(User) session.getAttribute("currentUser"); if (user==null ||
                !"volunteer".equals(user.getRole())) { response.sendRedirect(request.getContextPath()
                + "/pages/shared/login.jsp" ); return; } VolunteerStatsDAO statsDAO=new VolunteerStatsDAO();
                VolunteerStats stats=statsDAO.getStats(user.getUserId()); List<Guide> topGuides =
                statsDAO.getTopRatedGuides(user.getUserId(), 3);
                %>

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
                            border-bottom: 1px solid var(--border);
                            padding-bottom: 10px;
                        }

                        .stats-grid {
                            display: grid;
                            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
                            gap: 20px;
                        }

                        .stat-card {
                            background: var(--card);
                            padding: 20px;
                            border-radius: var(--radius-md);
                            box-shadow: var(--shadow-sm);
                            border: 1px solid var(--border);
                            text-align: center;
                            transition: all 0.2s;
                        }

                        .stat-card:hover {
                            transform: translateY(-3px);
                            box-shadow: var(--shadow-md);
                        }

                        .stat-card .number {
                            font-size: 2em;
                            font-weight: 700;
                            color: var(--primary);
                            margin-bottom: 5px;
                        }

                        .stat-card .label {
                            color: var(--muted-foreground);
                            font-weight: 500;
                            font-size: 0.9em;
                        }

                        .section-grid {
                            display: grid;
                            grid-template-columns: 2fr 1fr;
                            gap: 30px;
                        }

                        @media (max-width: 992px) {
                            .section-grid {
                                grid-template-columns: 1fr;
                            }
                        }

                        .quick-links {
                            display: grid;
                            grid-template-columns: repeat(auto-fill, minmax(140px, 1fr));
                            gap: 15px;
                            margin-top: 20px;
                        }

                        .quick-link-btn {
                            background: var(--muted);
                            color: var(--foreground);
                            padding: 15px;
                            border-radius: var(--radius-md);
                            text-align: center;
                            text-decoration: none;
                            font-weight: 600;
                            transition: all 0.2s;
                            border: 1px solid var(--border);
                            display: flex;
                            flex-direction: column;
                            align-items: center;
                            gap: 8px;
                        }

                        .quick-link-btn:hover {
                            background: var(--accent);
                            color: var(--accent-foreground);
                            transform: translateY(-2px);
                        }

                        .top-guides-list {
                            list-style: none;
                        }

                        .top-guide-item {
                            display: flex;
                            align-items: center;
                            gap: 15px;
                            padding: 12px 0;
                            border-bottom: 1px solid var(--border);
                        }

                        .top-guide-item:last-child {
                            border-bottom: none;
                        }

                        .top-guide-img {
                            width: 60px;
                            height: 40px;
                            object-fit: cover;
                            border-radius: 4px;
                            background: var(--muted);
                        }

                        .top-guide-info {
                            flex: 1;
                        }

                        .top-guide-title {
                            font-weight: 600;
                            color: var(--foreground);
                            display: block;
                            text-decoration: none;
                            margin-bottom: 2px;
                        }

                        .top-guide-title:hover {
                            color: var(--primary);
                            text-decoration: underline;
                        }

                        .top-guide-meta {
                            font-size: 0.85em;
                            color: var(--muted-foreground);
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
                                    href="${pageContext.request.contextPath}/pages/dashboards/volunteerdash/guideComments.jsp">Guide
                                    Comments</a></li>
                            <li><a
                                    href="${pageContext.request.contextPath}/pages/dashboards/volunteerdash/myProfile.jsp">My
                                    Profile</a></li>
                        </ul>
                    </aside>

                    <main class="container">
                        <h2>Dashboard</h2>

                        <div class="volunteer-stats">
                            <h3>Overview</h3>
                            <div class="stats-grid">
                                <div class="stat-card">
                                    <p class="number">
                                        <%= stats.getTotalGuides() %>
                                    </p>
                                    <p class="label">Total Guides</p>
                                </div>
                                <div class="stat-card">
                                    <p class="number">
                                        <%= stats.getTotalViews() %>
                                    </p>
                                    <p class="label">Total Views</p>
                                </div>
                                <div class="stat-card">
                                    <p class="number">
                                        <%= stats.getTotalLikes() %>
                                    </p>
                                    <p class="label">Total Likes</p>
                                </div>
                                <div class="stat-card">
                                    <p class="number">
                                        <%= stats.getApprovalRating() %>%
                                    </p>
                                    <p class="label">Approval Rating</p>
                                </div>
                            </div>
                        </div>

                        <div class="section-grid">
                            <!-- Top Guides -->
                            <div class="volunteer-stats">
                                <h3>Top Rated Guides</h3>
                                <% if (topGuides !=null && !topGuides.isEmpty()) { %>
                                    <ul class="top-guides-list">
                                        <% for (Guide g : topGuides) { %>
                                            <li class="top-guide-item">
                                                <c:if test="<%= g.getMainImagePath() != null %>">
                                                    <img src="${pageContext.request.contextPath}/<%= g.getMainImagePath() %>"
                                                        class="top-guide-img" alt="Guide">
                                                </c:if>
                                                <div class="top-guide-info">
                                                    <a href="${pageContext.request.contextPath}/ViewGuideServlet?id=<%= g.getGuideId() %>"
                                                        class="top-guide-title">
                                                        <%= g.getTitle() %>
                                                    </a>
                                                    <span class="top-guide-meta">
                                                        <%= g.getMainCategory() %> • <%= g.getViewCount() %> views
                                                    </span>
                                                </div>
                                            </li>
                                            <% } %>
                                    </ul>
                                    <% } else { %>
                                        <p style="color: var(--muted-foreground); padding: 10px 0;">No guides ratings
                                            yet.</p>
                                        <% } %>
                            </div>

                            <!-- Quick Actions -->
                            <div class="volunteer-stats">
                                <h3>Quick Actions</h3>
                                <div class="quick-links">
                                    <a href="${pageContext.request.contextPath}/guides/create" class="quick-link-btn">
                                        <span>✏️</span> Create Guide
                                    </a>
                                    <a href="${pageContext.request.contextPath}/pages/guides/my-guides.jsp"
                                        class="quick-link-btn">
                                        <span>📂</span> My Guides
                                    </a>
                                    <a href="${pageContext.request.contextPath}/pages/dashboards/volunteerdash/guideComments.jsp"
                                        class="quick-link-btn">
                                        <span>💬</span> Comments
                                    </a>
                                    <a href="${pageContext.request.contextPath}/pages/dashboards/volunteerdash/myProfile.jsp"
                                        class="quick-link-btn">
                                        <span>👤</span> Profile
                                    </a>
                                </div>
                            </div>
                        </div>
                    </main>

                    <script src="${pageContext.request.contextPath}/assets/js/dark-mode.js"></script>

                </body>

                </html>