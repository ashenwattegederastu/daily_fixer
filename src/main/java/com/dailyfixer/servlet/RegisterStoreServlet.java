package com.dailyfixer.servlet;

import com.dailyfixer.dao.StoreDAO;
import com.dailyfixer.dao.UserDAO;
import com.dailyfixer.model.Store;
import com.dailyfixer.model.User;
import com.dailyfixer.util.HashUtil;
import com.dailyfixer.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet(name = "RegisterStoreServlet", urlPatterns = {"/registerStore"})
public class RegisterStoreServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final StoreDAO storeDAO = new StoreDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("registerStore.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String firstName = req.getParameter("firstName");
        String lastName = req.getParameter("lastName");
        String username = req.getParameter("username");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String phone = req.getParameter("phone");
        String city = req.getParameter("city");
        String storeName = req.getParameter("storeName");
        String storeAddress = req.getParameter("storeAddress");
        String storeCity = req.getParameter("storeCity");
        String storeType = req.getParameter("storeType");

        StringBuilder errors = new StringBuilder();

        // --- Validation ---
        if (firstName == null || firstName.trim().isEmpty()) errors.append("First name required.<br>");
        if (lastName == null || lastName.trim().isEmpty()) errors.append("Last name required.<br>");
        if (username == null || username.trim().isEmpty()) errors.append("Username required.<br>");
        if (email == null || email.trim().isEmpty()) errors.append("Email required.<br>");
        if (password == null || password.trim().isEmpty()) errors.append("Password required.<br>");
        if (storeName == null || storeName.trim().isEmpty()) errors.append("Store name required.<br>");
        if (storeAddress == null || storeAddress.trim().isEmpty()) errors.append("Store address required.<br>");
        if (storeCity == null || storeCity.trim().isEmpty()) errors.append("Store city required.<br>");
        if (storeType == null || storeType.trim().isEmpty()) errors.append("Store type required.<br>");

        try {
            if (userDAO.isUsernameTaken(username)) errors.append("Username already exists.<br>");
            if (userDAO.isEmailTaken(email)) errors.append("Email already registered.<br>");

            if (errors.length() > 0) {
                req.setAttribute("errorMsg", errors.toString());
                req.getRequestDispatcher("registerStore.jsp").forward(req, resp);
                return;
            }

            // --- Save user first ---
            User user = new User();
            user.setFirstName(firstName);
            user.setLastName(lastName);
            user.setUsername(username);
            user.setEmail(email);
            user.setPassword(HashUtil.sha256(password));
            user.setPhoneNumber(phone);
            user.setCity(city);
            user.setRole("store");

            int userId = userDAO.saveUser(user); // ✅ get generated ID

            if (userId <= 0) {
                req.setAttribute("errorMsg", "Failed to create user account.");
                req.getRequestDispatcher("registerStore.jsp").forward(req, resp);
                return;
            }

            // --- Save store ---
            Store store = new Store();
            store.setUserId(userId);
            store.setStoreName(storeName);
            store.setStoreAddress(storeAddress);
            store.setStoreCity(storeCity);
            store.setStoreType(storeType);

            boolean storeSaved = storeDAO.addStore(store);

            if (!storeSaved) {
                // rollback user if store creation failed
                try (Connection con = DBConnection.getConnection();
                     PreparedStatement ps = con.prepareStatement("DELETE FROM users WHERE user_id = ?")) {
                    ps.setInt(1, userId);
                    ps.executeUpdate();
                } catch (Exception ignored) {}

                req.setAttribute("errorMsg", "Failed to create store record. Please try again.");
                req.getRequestDispatcher("registerStore.jsp").forward(req, resp);
                return;
            }

            // --- Success ---
            HttpSession session = req.getSession();
            session.setAttribute("successMsg", "Store registration successful. Please log in.");
            resp.sendRedirect("login.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMsg", "Server error: " + e.getMessage());
            req.getRequestDispatcher("registerStore.jsp").forward(req, resp);
        }
    }
}
