package com.dailyfixer.product;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import com.dailyfixer.model.Product;
import com.dailyfixer.dao.ProductDAO;
import com.dailyfixer.model.User;

@MultipartConfig(maxFileSize = 16177215) // 16 MB max
public class AddProductServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Get logged-in User object from session
        HttpSession session = request.getSession(false); // do not create new session
        if (session == null) {
            response.sendRedirect("../../login.jsp");
            return;
        }

        User user = (User) session.getAttribute("currentUser");
        if (user == null || !"store".equals(user.getRole())) {
            response.sendRedirect("../../login.jsp"); // only store users can add products
            return;
        }

        String storeUsername = user.getUsername(); // safe to use for DB

        // 2. Get form parameters
        String name = request.getParameter("name");
        String type = request.getParameter("type");
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        String quantityUnit = request.getParameter("quantityUnit");
        double price = Double.parseDouble(request.getParameter("price"));
        String description = request.getParameter("description");

        // 3. Get uploaded image
        InputStream inputStream = null;
        Part filePart = request.getPart("image");
        if (filePart != null && filePart.getSize() > 0) {
            inputStream = filePart.getInputStream();
        }

        try {
            // 4. Create Product object
            Product p = new Product();
            p.setName(name);
            p.setType(type);
            p.setQuantity(quantity);
            p.setQuantityUnit(quantityUnit);
            p.setPrice(price);
            p.setStoreUsername(storeUsername);
            p.setDescription(description);
            if (inputStream != null) p.setImage(inputStream.readAllBytes());

            // 5. Save to database
            new ProductDAO().addProduct(p);

            // 6. Redirect to product list
            response.sendRedirect("ListProductsServlet");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error adding product: " + e.getMessage());
        }
    }
}
