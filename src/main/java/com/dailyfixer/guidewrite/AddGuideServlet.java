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
import java.io.InputStream;

@WebServlet("/AddGuideServlet")
@MultipartConfig(maxFileSize = 16177215)
public class AddGuideServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        int volunteerId = currentUser.getUserId();

        String title = request.getParameter("title");
        Part mainImagePart = request.getPart("mainImage");
        byte[] mainImageBytes = null;
        if (mainImagePart != null && mainImagePart.getSize() > 0) {
            mainImageBytes = mainImagePart.getInputStream().readAllBytes();
        }

        Guide guide = new Guide(volunteerId, title, mainImageBytes);

        // Requirements
        String[] reqArray = request.getParameterValues("requirements");
        List<String> requirements = new ArrayList<>();
        if (reqArray != null) {
            requirements.addAll(Arrays.asList(reqArray));
        }

        // Steps
        List<GuideStep> steps = new ArrayList<>();
        String[] stepTitles = request.getParameterValues("stepTitle");
        String[] stepDescriptions = request.getParameterValues("stepDescription");
        Collection<Part> parts = request.getParts();

        if (stepTitles != null && stepDescriptions != null) {
            int stepCount = Math.min(stepTitles.length, stepDescriptions.length);

            int stepIndex = 0;
            Iterator<Part> partIterator = parts.iterator();
            for (int i = 0; i < stepCount; i++) {
                byte[] imageBytes = null;

                // Find the corresponding step image
                while (partIterator.hasNext()) {
                    Part p = partIterator.next();
                    if (p.getName().equals("stepImage") && p.getSize() > 0) {
                        imageBytes = p.getInputStream().readAllBytes();
                        break; // take first available image for this step
                    }
                }

                GuideStep step = new GuideStep(0, stepTitles[i], stepDescriptions[i], imageBytes);
                steps.add(step);
                stepIndex++;
            }
        }

        GuideDAO dao = new GuideDAO();
        dao.addGuide(guide, requirements, steps);

        response.sendRedirect(request.getContextPath() + "/pages/dashboards/volunteerdash/myguides.jsp?success=true");
    }
}
