package com.dailyfixer.servlet;

import com.dailyfixer.dao.UserDAO;
import com.dailyfixer.model.User;
import com.dailyfixer.util.HashUtil;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        try {
            String hashed = HashUtil.sha256(password == null ? "" : password);
            User user = userDAO.findByUsernameAndPassword(username, hashed);

            if (user != null) {
                // Set the com.dailyfixer.user in session
                HttpSession session = req.getSession(true);
                session.setAttribute("currentUser", user);

                // Check for redirect URL (from product details page or checkout)
                String redirectUrl = req.getParameter("redirect");
                System.out.println("LoginServlet - redirect parameter (raw): " + redirectUrl);
                
                // Decode the redirect URL if it's encoded
                if (redirectUrl != null && !redirectUrl.isEmpty()) {
                    try {
                        redirectUrl = java.net.URLDecoder.decode(redirectUrl, "UTF-8");
                        System.out.println("LoginServlet - redirect parameter (decoded): " + redirectUrl);
                    } catch (Exception e) {
                        System.err.println("Error decoding redirect URL: " + e.getMessage());
                    }
                }
                
                if (redirectUrl == null || redirectUrl.isEmpty()) {
                    // Also check session for redirect (from checkout.jsp)
                    redirectUrl = (String) session.getAttribute("redirectAfterLogin");
                    System.out.println("LoginServlet - redirect from session: " + redirectUrl);
                    if (redirectUrl != null) {
                        session.removeAttribute("redirectAfterLogin");
                    }
                }

                // Redirect based on role
                String role = user.getRole() != null ? user.getRole().trim().toLowerCase() : "";
                System.out.println("LoginServlet - user role: " + role);
                System.out.println("LoginServlet - final redirectUrl: " + redirectUrl);

                switch (role) {
                    case "admin":
                        resp.sendRedirect(req.getContextPath() + "/pages/dashboards/admindash/admindashmain.jsp");
                        break;
                    case "volunteer":
                        resp.sendRedirect(req.getContextPath() + "/pages/dashboards/volunteerdash/volunteerdashmain.jsp");
                        break;
                    case "technician":
                        resp.sendRedirect(req.getContextPath() + "/pages/dashboards/techniciandash/techniciandashmain.jsp");
                        break;
                    case "store":
                        resp.sendRedirect(req.getContextPath() + "/pages/dashboards/storedash/storedashmain.jsp");
                        break;
                    case "driver":
                        resp.sendRedirect(req.getContextPath() + "/pages/dashboards/driverdash/driverdashmain.jsp");
                        break;
                    case "user":
                    default:
                        // For regular users, redirect to the stored URL if available, otherwise go to home
                        if (redirectUrl != null && !redirectUrl.isEmpty()) {
                            String contextPath = req.getContextPath();
                            String finalRedirectUrl = redirectUrl;
                            
                            // Normalize the redirect URL
                            // If it's a full URL (starts with http:// or https://), extract just the path
                            if (redirectUrl.startsWith("http://") || redirectUrl.startsWith("https://")) {
                                try {
                                    java.net.URL url = new java.net.URL(redirectUrl);
                                    String path = url.getPath();
                                    String query = url.getQuery();
                                    if (query != null && !query.isEmpty()) {
                                        finalRedirectUrl = path + "?" + query;
                                    } else {
                                        finalRedirectUrl = path;
                                    }
                                } catch (Exception e) {
                                    System.err.println("Error parsing redirect URL: " + e.getMessage());
                                }
                            }
                            
                            // Remove context path if it appears at the start (to avoid duplication)
                            if (finalRedirectUrl.startsWith(contextPath)) {
                                finalRedirectUrl = finalRedirectUrl.substring(contextPath.length());
                            }
                            
                            // Ensure it starts with / for proper path
                            if (!finalRedirectUrl.startsWith("/")) {
                                finalRedirectUrl = "/" + finalRedirectUrl;
                            }
                            
                            // Build the final URL with context path
                            finalRedirectUrl = contextPath + finalRedirectUrl;
                            
                            System.out.println("LoginServlet - redirecting user to: " + finalRedirectUrl);
                            resp.sendRedirect(finalRedirectUrl);
                        } else {
                            System.out.println("LoginServlet - no redirect URL, going to home");
                            resp.sendRedirect(req.getContextPath() + "/index.jsp");
                        }
                        break;
                }

            } else {
                // Preserve redirect parameter on login failure
                String redirectUrl = req.getParameter("redirect");
                if (redirectUrl != null && !redirectUrl.isEmpty()) {
                    req.setAttribute("redirect", redirectUrl);
                }
                req.setAttribute("loginError", "Invalid username or password");
                req.getRequestDispatcher("login.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Preserve redirect parameter on error
            String redirectUrl = req.getParameter("redirect");
            if (redirectUrl != null && !redirectUrl.isEmpty()) {
                req.setAttribute("redirect", redirectUrl);
            }
            req.setAttribute("loginError", "Server error: " + e.getMessage());
            req.getRequestDispatcher("login.jsp").forward(req, resp);
        }
    }
}
