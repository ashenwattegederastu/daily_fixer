package com.dailyfixer.guidewrite;

import com.dailyfixer.dao.GuideDAO;
import com.dailyfixer.model.Guide;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet("/ImageServlet")
public class ImageServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null) return;

        int guideId = Integer.parseInt(idStr);
        Guide guide = new GuideDAO().getGuideById(guideId);
        if (guide != null && guide.getMainImage() != null) {
            response.setContentType("image/jpeg");
            response.getOutputStream().write(guide.getMainImage());
        }
    }
}
