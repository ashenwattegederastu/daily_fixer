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
                // Set the user in session
                HttpSession session = req.getSession(true);
                session.setAttribute("currentUser", user);

                // Redirect everyone to index.jsp
                resp.sendRedirect(req.getContextPath() + "/index.jsp");
            } else {
                req.setAttribute("loginError", "Invalid username or password");
                req.getRequestDispatcher("login.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("loginError", "Server error: " + e.getMessage());
            req.getRequestDispatcher("login.jsp").forward(req, resp);
        }
    }
}
