package com.dailyfixer.guidewrite;

import com.dailyfixer.dao.GuideDAO;
import com.dailyfixer.model.Guide;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/SearchGuidesServlet")
public class SearchGuidesServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        String mainCategory = request.getParameter("mainCategory");
        String subCategory = request.getParameter("subCategory");

        GuideDAO dao = new GuideDAO();
        List<Guide> guides;
        
        // If all parameters are empty, get all guides
        if ((keyword == null || keyword.trim().isEmpty()) &&
            (mainCategory == null || mainCategory.trim().isEmpty()) &&
            (subCategory == null || subCategory.trim().isEmpty())) {
            guides = dao.getAllGuides();
        } else {
            guides = dao.searchGuides(keyword, mainCategory, subCategory);
        }

        request.setAttribute("guides", guides);
        request.setAttribute("keyword", keyword);
        request.setAttribute("mainCategory", mainCategory);
        request.setAttribute("subCategory", subCategory);
        
        RequestDispatcher rd = request.getRequestDispatcher("/pages/guides/listguides.jsp");
        rd.forward(request, response);
    }
}
