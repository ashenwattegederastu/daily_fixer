package com.dailyfixer.web.servlet.auth;

import com.dailyfixer.dao.UserDAO;
import com.dailyfixer.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;

@WebServlet("/SignupServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 10 * 1024 * 1024)
public class SignupServlet extends HttpServlet {
    private UserDAO dao = new UserDAO();

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String username = req.getParameter("username");
            String password = req.getParameter("password");
            String fname = req.getParameter("fname");
            String lname = req.getParameter("lname");
            String phone = req.getParameter("phone");
            String email = req.getParameter("email");

            // handle file upload
            Part filePart = req.getPart("profilepic");
            String fileName = null;
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();

            if (filePart != null && filePart.getSize() > 0) {
                fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                filePart.write(uploadPath + File.separator + fileName);
            }

            User u = new User();
            u.setUsername(username);
            u.setPassword(password);
            u.setFname(fname);
            u.setLname(lname);
            u.setPhone(phone);
            u.setEmail(email);
            u.setProfilepic(fileName);

            dao.registerUser(u); // usertype automatically 'user'

            // auto-login after signup
            HttpSession session = req.getSession();
            session.setAttribute("user", u);

            // redirect to user dashboard
            resp.sendRedirect(req.getContextPath() + "/pages/dashboards/userdash/userdashmain.jsp");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
