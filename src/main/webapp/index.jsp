<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ page session="true" %>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Daily Fixer - Fix, Learn, Restore</title>
                <link
                    href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&family=Inter:wght@400;500;600;700&family=Lora:wght@400;500;600;700&family=IBM+Plex+Mono:wght@400;500;600&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/framework.css">
            </head>

            <body>
                <!-- Navigation -->
                <nav id="navbar" class="public-nav">
                    <div class="nav-container">
                        <%-- <div class="logo">Daily Fixer
                    </div>--%>
                    <a href="${pageContext.request.contextPath}/index.jsp" class="logo">Daily Fixer</a>
                    <ul class="nav-links">
                        <li><a href="${pageContext.request.contextPath}/diagnostic.jsp">Diagnostic Tool</a></li>
                        <li><a href="${pageContext.request.contextPath}/guides">View Repair Guides</a></li>
                        <li><a href="${pageContext.request.contextPath}/findtech.jsp">Book a Technician</a></li>
                        <li><a href="${pageContext.request.contextPath}/store_main.jsp">Store</a></li>
                    </ul>

                    <!-- Dynamic Login/Logout -->
                    <div class="nav-buttons">
                        <button id="theme-toggle-btn" class="theme-toggle" onclick="toggleTheme()"
                            aria-label="Toggle dark mode">🌙 Dark</button>
                        <c:choose>
                            <c:when test="${not empty sessionScope.currentUser}">
                                <!-- User is logged in -->
                                <a href="${pageContext.request.contextPath}/pages/dashboards/${sessionScope.currentUser.role}dash/${sessionScope.currentUser.role}dashmain.jsp"
                                    class="btn-login"
                                    style="text-decoration: none; padding: 0.6rem 1.2rem; display: inline-block;">
                                    Hi, ${sessionScope.currentUser.firstName}
                                </a>
                                <a href="${pageContext.request.contextPath}/logout" class="btn-logout"
                                    style="text-decoration: none;">Logout</a>
                            </c:when>
                            <c:otherwise>
                                <!-- Guest -->
                                <a href="${pageContext.request.contextPath}/login.jsp" class="btn-login">Login</a>
                                <a href="${pageContext.request.contextPath}/preliminarySignup.jsp"
                                    class="btn-signup">Sign Up</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    </div>
                </nav>

                <!-- Hero Section 1: Community -->
                <section class="hero-section active" id="hero1">
                    <div class="hero-content">
                        <h1>Join a community that helps you fix, learn, and restore what matters.</h1>
                        <p>Connect with thousands of people who share your passion for fixing and learning.</p>
                        <c:choose>
                            <c:when test="${not empty sessionScope.currentUser}">
                                <a href="${pageContext.request.contextPath}/diagnostic.jsp" class="hero-cta">Start
                                    Diagnosing</a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/preliminarySignup.jsp" class="hero-cta">Get
                                    Started</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="scroll-indicator">
                        <div class="chevron"></div>
                    </div>
                </section>

                <!-- Hero Section 2: View Guides -->
                <section class="hero-section" id="hero2">
                    <div class="hero-content">
                        <h1>Master Repairs with Our Guides</h1>
                        <p>Access thousands of step-by-step repair guides created by experts and community members.</p>
                        <a href="${pageContext.request.contextPath}/listguides.jsp" class="hero-cta">Explore Guides</a>
                    </div>
                    <div class="scroll-indicator">
                        <div class="chevron"></div>
                    </div>
                </section>

                <!-- Features Section: View Guides -->
                <section class="features-section" id="guides">
                    <div class="features-container">
                        <h2 class="section-title">Why Choose Our Repair Guides?</h2>
                        <div class="features-grid">
                            <div class="feature-card">
                                <div class="feature-icon">📚</div>
                                <h3>Comprehensive Library</h3>
                                <p>Thousands of detailed guides covering everything from electronics to appliances.</p>
                            </div>
                            <div class="feature-card">
                                <div class="feature-icon">👥</div>
                                <h3>Community Driven</h3>
                                <p>Learn from experts and experienced technicians in our active community.</p>
                            </div>
                            <div class="feature-card">
                                <div class="feature-icon">⚡</div>
                                <h3>Easy to Follow</h3>
                                <p>Step-by-step instructions with photos and videos for every repair.</p>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Hero Section 3: Technician Booking -->
                <section class="hero-section" id="hero3">
                    <div class="hero-content">
                        <h1>Need Professional Help?</h1>
                        <p>Book a certified technician for complex repairs. Fast, reliable, and affordable.</p>
                        <a href="${pageContext.request.contextPath}/findtech.jsp" class="hero-cta">Book Now</a>
                    </div>
                    <div class="scroll-indicator">
                        <div class="chevron"></div>
                    </div>
                </section>

                <!-- Features Section: Technician Booking -->
                <section class="features-section" id="technician">
                    <div class="features-container">
                        <h2 class="section-title">Professional Technician Services</h2>
                        <div class="features-grid">
                            <div class="feature-card">
                                <div class="feature-icon">✓</div>
                                <h3>Certified Professionals</h3>
                                <p>All technicians are verified and certified in their respective fields.</p>
                            </div>
                            <div class="feature-card">
                                <div class="feature-icon">⏱️</div>
                                <h3>Quick Response</h3>
                                <p>Get a technician at your door within 24 hours in most areas.</p>
                            </div>
                            <div class="feature-card">
                                <div class="feature-icon">💰</div>
                                <h3>Transparent Pricing</h3>
                                <p>No hidden fees. Get a quote before any work begins.</p>
                            </div>
                        </div>
                    </div>
                </section>

                <script>
                    // Navbar scroll effect
                    const navbar = document.getElementById('navbar');
                    window.addEventListener('scroll', () => {
                        if (window.scrollY > 50) {
                            navbar.classList.add('scrolled');
                        } else {
                            navbar.classList.remove('scrolled');
                        }
                    });

                    // Hero section visibility on scroll
                    const heroSections = document.querySelectorAll('.hero-section');
                    const observerOptions = {
                        threshold: 0.5
                    };

                    const observer = new IntersectionObserver((entries) => {
                        entries.forEach(entry => {
                            if (entry.isIntersecting) {
                                entry.target.classList.add('active');
                            } else {
                                entry.target.classList.remove('active');
                            }
                        });
                    }, observerOptions);

                    heroSections.forEach(section => {
                        observer.observe(section);
                    });

                    // Smooth scroll for internal links (optional: you can keep or remove if using full paths)
                    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
                        anchor.addEventListener('click', function (e) {
                            e.preventDefault();
                            const target = document.querySelector(this.getAttribute('href'));
                            if (target) {
                                target.scrollIntoView({
                                    behavior: 'smooth',
                                    block: 'start'
                                });
                            }
                        });
                    });
                </script>
                <script src="${pageContext.request.contextPath}/assets/js/dark-mode.js"></script>
            </body>

            </html>