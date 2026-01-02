package com.dailyfixer.guidewrite;

import com.dailyfixer.dao.GuideDAO;
import com.dailyfixer.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/RateGuideServlet")
public class RateGuideServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String guideIdStr = request.getParameter("guideId");
        String rating = request.getParameter("rating");
        
        if (guideIdStr == null || rating == null) {
            response.sendRedirect(request.getContextPath() + "/ViewGuidesServlet");
            return;
        }

        int guideId = Integer.parseInt(guideIdStr);
        
        // Validate rating value
        if (!"UP".equals(rating) && !"DOWN".equals(rating)) {
            response.sendRedirect(request.getContextPath() + "/ViewGuideServlet?id=" + guideId);
            return;
        }

        GuideDAO dao = new GuideDAO();
        dao.addOrUpdateRating(guideId, currentUser.getUserId(), rating);

        response.sendRedirect(request.getContextPath() + "/ViewGuideServlet?id=" + guideId);
    }
}
