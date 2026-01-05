package com.dailyfixer.product;

import com.dailyfixer.dao.ProductDAO;
import com.dailyfixer.model.Product;
import com.dailyfixer.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

import jakarta.servlet.annotation.WebServlet;

@WebServlet("/ListProductsServlet")
public class ListProductsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("../../login.jsp");
            return;
        }

        User user = (User) session.getAttribute("currentUser");
        if (user == null || !"store".equals(user.getRole())) {
            response.sendRedirect("../../login.jsp");
            return;
        }

        String storeUsername = user.getUsername();

        try {
            List<Product> products = new ProductDAO().getAllProducts(storeUsername);
            request.setAttribute("products", products);
            request.getRequestDispatcher("/pages/dashboards/storedash/productList.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
