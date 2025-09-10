package com.dailyfixer.web.servlet.auth;

import com.dailyfixer.dao.UserDAO;
import com.dailyfixer.model.User;
import com.dailyfixer.model.UserDriver;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/DriverSignupServlet")
public class DriverSignupServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // Create user
        User user = new User();
        user.setUsername(request.getParameter("username"));
        user.setPassword(request.getParameter("password"));
        user.setFname(request.getParameter("fname"));
        user.setLname(request.getParameter("lname"));
        user.setPhone(request.getParameter("phone"));
        user.setEmail(request.getParameter("email"));
        user.setProfilepic(request.getParameter("profilepic"));

        // Create driver-specific data
        UserDriver driver = new UserDriver();
        driver.setRealPic(request.getParameter("real_pic"));
        driver.setServiceArea(request.getParameter("service_area"));
        driver.setLicensePic(request.getParameter("license_pic"));

        boolean registered = userDAO.registerDriver(user, driver);

        if(registered) {
            response.sendRedirect(request.getContextPath() + "/pages/shared/login.jsp");
        } else {
            request.setAttribute("error", "Signup failed. Try again.");
            request.getRequestDispatcher("/pages/auth/driversignup.jsp").forward(request, response);
        }
    }
}
