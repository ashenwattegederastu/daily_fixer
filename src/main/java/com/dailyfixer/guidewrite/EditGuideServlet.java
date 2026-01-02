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
        
        // Check if user can modify this guide
        if (!dao.canUserModifyGuide(guideId, currentUser.getUserId(), currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/pages/dashboards/volunteerdash/myguides.jsp?error=unauthorized");
            return;
        }

        Guide guide = dao.getGuideById(guideId);
        if (guide == null) {
            response.sendRedirect(request.getContextPath() + "/pages/dashboards/volunteerdash/myguides.jsp");
            return;
        }

        request.setAttribute("guide", guide);
        
        String role = currentUser.getRole();
        if ("admin".equalsIgnoreCase(role)) {
            RequestDispatcher rd = request.getRequestDispatcher("/pages/dashboards/admindash/editGuide.jsp");
            rd.forward(request, response);
        } else {
            RequestDispatcher rd = request.getRequestDispatcher("/pages/dashboards/volunteerdash/editGuide.jsp");
            rd.forward(request, response);
        }
    }

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
        if (guideIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/pages/dashboards/volunteerdash/myguides.jsp");
            return;
        }

        int guideId = Integer.parseInt(guideIdStr);
        GuideDAO dao = new GuideDAO();
        
        // Check if user can modify this guide
        if (!dao.canUserModifyGuide(guideId, currentUser.getUserId(), currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/pages/dashboards/volunteerdash/myguides.jsp?error=unauthorized");
            return;
        }

        // Get existing guide to preserve image if not updated
        Guide existingGuide = dao.getGuideById(guideId);

        String title = request.getParameter("title");
        String mainCategory = request.getParameter("mainCategory");
        String subCategory = request.getParameter("subCategory");
        String youtubeUrl = request.getParameter("youtubeUrl");
        
        Part mainImagePart = request.getPart("mainImage");
        byte[] mainImageBytes = null;
        if (mainImagePart != null && mainImagePart.getSize() > 0) {
            mainImageBytes = mainImagePart.getInputStream().readAllBytes();
        } else {
            // Keep existing image
            mainImageBytes = existingGuide.getMainImage();
        }

        Guide guide = new Guide(title, mainImageBytes, mainCategory, subCategory, 
                                youtubeUrl, existingGuide.getCreatedBy(), existingGuide.getCreatedRole());
        guide.setGuideId(guideId);

        // Requirements
        String[] reqArray = request.getParameterValues("requirements");
        List<String> requirements = new ArrayList<>();
        if (reqArray != null) {
            for (String req : reqArray) {
                if (req != null && !req.trim().isEmpty()) {
                    requirements.add(req.trim());
                }
            }
        }

        // Steps
        List<GuideStep> steps = new ArrayList<>();
        String[] stepTitles = request.getParameterValues("stepTitle");
        String[] stepBodies = request.getParameterValues("stepBody");

        if (stepTitles != null) {
            Collection<Part> parts = request.getParts();
            List<Part> stepImageParts = new ArrayList<>();
            for (Part p : parts) {
                if ("stepImage".equals(p.getName()) && p.getSize() > 0) {
                    stepImageParts.add(p);
                }
            }
            
            int imageIndex = 0;
            for (int i = 0; i < stepTitles.length; i++) {
                String stepTitle = stepTitles[i];
                String stepBody = (stepBodies != null && i < stepBodies.length) ? stepBodies[i] : "";
                
                if (stepTitle != null && !stepTitle.trim().isEmpty()) {
                    GuideStep step = new GuideStep(guideId, i + 1, stepTitle, stepBody);
                    
                    List<byte[]> images = new ArrayList<>();
                    if (imageIndex < stepImageParts.size()) {
                        byte[] imageBytes = stepImageParts.get(imageIndex).getInputStream().readAllBytes();
                        if (imageBytes.length > 0) {
                            images.add(imageBytes);
                        }
                        imageIndex++;
                    }
                    step.setImages(images);
                    steps.add(step);
                }
            }
        }

        dao.updateGuide(guide, requirements, steps);

        String role = currentUser.getRole();
        if ("admin".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/pages/dashboards/admindash/guides.jsp?success=updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/pages/dashboards/volunteerdash/myguides.jsp?success=updated");
        }
    }
}
