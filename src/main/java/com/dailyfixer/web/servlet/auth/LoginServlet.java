package com.dailyfixer.web.servlet.auth;

import com.dailyfixer.dao.UserDAO;
import com.dailyfixer.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        User user = userDAO.validateUser(username, password);

        if(user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            // Redirect based on usertype
//            switch(user.getUsertype()) {
//                case "admin":
//                    response.sendRedirect(request.getContextPath() + "/pages/dashboards/admindash/admindashmain.jsp");
//                    break;
//                case "driver":
//                    response.sendRedirect(request.getContextPath() + "/pages/dashboards/driverdash/driverdashmain.jsp");
//                    break;
//                default:
//                    response.sendRedirect(request.getContextPath() + "/index.jsp");
//            }
            // After successful login
                // store the user in session
            response.sendRedirect(request.getContextPath() + "/index.jsp");

        } else {
            request.setAttribute("error", "Invalid username or password");
            request.getRequestDispatcher("/pages/shared/login.jsp").forward(request, response);
        }
    }
}
