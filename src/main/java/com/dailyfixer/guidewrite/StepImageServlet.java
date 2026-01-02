package com.dailyfixer.guidewrite;

import com.dailyfixer.dao.GuideDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet("/StepImageServlet")
public class StepImageServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String imageIdStr = request.getParameter("id");
        if (imageIdStr == null) return;

        int imageId = Integer.parseInt(imageIdStr);
        GuideDAO dao = new GuideDAO();
        byte[] imageData = dao.getStepImage(imageId);
        
        if (imageData != null && imageData.length > 0) {
            response.setContentType("image/jpeg");
            response.getOutputStream().write(imageData);
        }
    }
}
