package com.dailyfixer.product;

import com.dailyfixer.dao.ProductDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class DeleteProductServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("productId"));
            new ProductDAO().deleteProduct(id);
                response.sendRedirect(request.getContextPath() + "/ListProductsServlet?deleted=success");

//            response.sendRedirect("ListProductsServlet");

        } catch (Exception e) { e.printStackTrace(); }
    }
}
