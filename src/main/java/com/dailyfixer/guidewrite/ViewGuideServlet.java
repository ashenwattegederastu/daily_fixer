package com.dailyfixer.guidewrite;

import com.dailyfixer.dao.GuideDAO;
import com.dailyfixer.model.Guide;
import com.dailyfixer.model.GuideComment;
import com.dailyfixer.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.List;

@WebServlet("/ViewGuideServlet")
public class ViewGuideServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect(request.getContextPath() + "/ViewGuidesServlet");
            return;
        }
        int guideId = Integer.parseInt(idStr);
        GuideDAO dao = new GuideDAO();
        Guide guide = dao.getGuideById(guideId);

        if (guide == null) {
            response.sendRedirect(request.getContextPath() + "/ViewGuidesServlet");
            return;
        }

        // Get comments
        List<GuideComment> comments = dao.getComments(guideId);
        
        // Get user rating if logged in
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        String userRating = null;
        if (currentUser != null) {
            userRating = dao.getUserRating(guideId, currentUser.getUserId());
        }

        request.setAttribute("guide", guide);
        request.setAttribute("comments", comments);
        request.setAttribute("userRating", userRating);
        
        RequestDispatcher rd = request.getRequestDispatcher("/pages/guides/viewguide.jsp");
        rd.forward(request, response);
    }
}
