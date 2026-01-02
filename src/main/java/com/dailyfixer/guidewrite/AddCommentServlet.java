package com.dailyfixer.guidewrite;

import com.dailyfixer.dao.GuideDAO;
import com.dailyfixer.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/AddCommentServlet")
public class AddCommentServlet extends HttpServlet {
    
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
        String comment = request.getParameter("comment");
        
        if (guideIdStr == null || comment == null || comment.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/ViewGuidesServlet");
            return;
        }

        int guideId = Integer.parseInt(guideIdStr);

        GuideDAO dao = new GuideDAO();
        dao.addComment(guideId, currentUser.getUserId(), comment.trim());

        response.sendRedirect(request.getContextPath() + "/ViewGuideServlet?id=" + guideId);
    }
}
