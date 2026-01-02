package com.dailyfixer.guidewrite;

import com.dailyfixer.dao.GuideDAO;
import com.dailyfixer.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/DeleteCommentServlet")
public class DeleteCommentServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String commentIdStr = request.getParameter("commentId");
        String guideIdStr = request.getParameter("guideId");
        
        if (commentIdStr == null || guideIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/ViewGuidesServlet");
            return;
        }

        int commentId = Integer.parseInt(commentIdStr);
        int guideId = Integer.parseInt(guideIdStr);

        // Delete only if user owns the comment
        GuideDAO dao = new GuideDAO();
        dao.deleteComment(commentId, currentUser.getUserId());

        response.sendRedirect(request.getContextPath() + "/ViewGuideServlet?id=" + guideId);
    }
}
