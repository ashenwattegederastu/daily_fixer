<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>

        <header class="topbar">
            <div class="logo-area" style="display: flex; align-items: center; gap: 15px;">
                <div class="hamburger" id="sidebar-toggle">
                    <span></span>
                    <span></span>
                    <span></span>
                </div>
                <a href="${pageContext.request.contextPath}/pages/dashboards/userdash/userdashmain.jsp"
                    class="logo">Daily Fixer</a>
            </div>

            <div class="panel-name">User Panel</div>

            <div class="topbar-actions">
                <a href="${pageContext.request.contextPath}" class="home-btn"
                    style="padding: 0.6rem 1.2rem; background: oklch(0.6290 0.1902 156.4499); border: none; color: white; border-radius: var(--radius-md); font-weight: 600; font-size: 0.9rem; text-decoration: none; display: inline-block; transition: all 0.3s ease;">
                    Home
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Log Out</a>
            </div>
        </header>