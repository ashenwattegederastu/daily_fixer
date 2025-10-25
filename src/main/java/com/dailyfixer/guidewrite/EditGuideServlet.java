package com.dailyfixer.guidewrite;

import com.dailyfixer.dao.GuideDAO;
import com.dailyfixer.model.Guide;
import com.dailyfixer.model.GuideStep;
import com.dailyfixer.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/EditGuideServlet")
@MultipartConfig(maxFileSize = 16177215)
public class EditGuideServlet extends HttpServlet {
    
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

        if (guide == null || guide.getVolunteerId() != currentUser.getUserId()) {
            response.sendRedirect(request.getContextPath() + "/pages/dashboards/volunteerdash/myguides.jsp");
            return;
        }

        request.setAttribute("guide", guide);
        RequestDispatcher rd = request.getRequestDispatcher("/pages/dashboards/volunteerdash/editGuide.jsp");
        rd.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int guideId = Integer.parseInt(request.getParameter("guideId"));
        String title = request.getParameter("title");
        
        GuideDAO dao = new GuideDAO();
        Guide existingGuide = dao.getGuideById(guideId);
        
        if (existingGuide == null || existingGuide.getVolunteerId() != currentUser.getUserId()) {
            response.sendRedirect(request.getContextPath() + "/pages/dashboards/volunteerdash/myguides.jsp");
            return;
        }

        // Handle main image
        Part mainImagePart = request.getPart("mainImage");
        byte[] mainImageBytes = existingGuide.getMainImage(); // Keep existing if no new upload
        if (mainImagePart != null && mainImagePart.getSize() > 0) {
            mainImageBytes = mainImagePart.getInputStream().readAllBytes();
        }

        Guide guide = new Guide();
        guide.setGuideId(guideId);
        guide.setVolunteerId(currentUser.getUserId());
        guide.setTitle(title);
        guide.setMainImage(mainImageBytes);

        // Requirements
        String[] reqArray = request.getParameterValues("requirements");
        List<String> requirements = new ArrayList<>();
        if (reqArray != null) {
            for (String req : reqArray) {
                if (req != null && !req.trim().isEmpty()) {
                    requirements.add(req);
                }
            }
        }

        // Steps
        List<GuideStep> steps = new ArrayList<>();
        String[] stepTitles = request.getParameterValues("stepTitle");
        String[] stepDescriptions = request.getParameterValues("stepDescription");
        Collection<Part> parts = request.getParts();

        if (stepTitles != null && stepDescriptions != null) {
            int stepCount = Math.min(stepTitles.length, stepDescriptions.length);
            
            // Collect all step image parts in order
            List<Part> stepImageParts = new ArrayList<>();
            for (Part p : parts) {
                if ("stepImage".equals(p.getName())) {
                    stepImageParts.add(p);
                }
            }

            for (int i = 0; i < stepCount; i++) {
                byte[] imageBytes = null;
                
                // Get corresponding image part if available
                if (i < stepImageParts.size()) {
                    Part p = stepImageParts.get(i);
                    if (p.getSize() > 0) {
                        imageBytes = p.getInputStream().readAllBytes();
                    }
                }

                GuideStep step = new GuideStep(0, stepTitles[i], stepDescriptions[i], imageBytes);
                steps.add(step);
            }
        }

        dao.updateGuide(guide, requirements, steps);

        response.sendRedirect(request.getContextPath() + "/pages/dashboards/volunteerdash/myguides.jsp?updated=true");
    }
}
