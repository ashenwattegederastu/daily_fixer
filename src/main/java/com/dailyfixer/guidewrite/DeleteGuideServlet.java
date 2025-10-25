package com.dailyfixer.guidewrite;

import com.dailyfixer.dao.GuideDAO;
import com.dailyfixer.model.Guide;
import com.dailyfixer.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/DeleteGuideServlet")
public class DeleteGuideServlet extends HttpServlet {
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
        Guide guide = dao.getGuideById(guideId);

        // Verify ownership before deleting
        if (guide != null && guide.getVolunteerId() == currentUser.getUserId()) {
            dao.deleteGuide(guideId);
        }

        response.sendRedirect(request.getContextPath() + "/pages/dashboards/volunteerdash/myguides.jsp?deleted=true");
    }
}
