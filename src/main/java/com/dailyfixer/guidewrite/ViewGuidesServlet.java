package com.dailyfixer.guidewrite;

import com.dailyfixer.dao.GuideDAO;
import com.dailyfixer.model.Guide;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/ViewGuidesServlet")
public class ViewGuidesServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        GuideDAO dao = new GuideDAO();
        List<Guide> guides = dao.getAllGuides(); // fetch all guides from DB

        request.setAttribute("guides", guides); // set guides in request
        RequestDispatcher rd = request.getRequestDispatcher("/pages/guides/viewguides.jsp");
        rd.forward(request, response);
    }
}
