package com.dailyfixer.guidewrite;

import com.dailyfixer.dao.GuideDAO;
import com.dailyfixer.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/DeleteGuideServlet")
public class DeleteGuideServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect(request.getContextPath() + "/pages/dashboards/volunteerdash/myguides.jsp");
            return;
        }

        int guideId = Integer.parseInt(idStr);
        GuideDAO dao = new GuideDAO();
        
        // Check if user can delete this guide
        if (!dao.canUserModifyGuide(guideId, currentUser.getUserId(), currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/pages/dashboards/volunteerdash/myguides.jsp?error=unauthorized");
            return;
        }

        dao.deleteGuide(guideId);

        String role = currentUser.getRole();
        if ("admin".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/pages/dashboards/admindash/guides.jsp?success=deleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/pages/dashboards/volunteerdash/myguides.jsp?success=deleted");
        }
    }
}
