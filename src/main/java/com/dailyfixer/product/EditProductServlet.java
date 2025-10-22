package com.dailyfixer.product;

import java.io.*;

import com.dailyfixer.dao.ProductDAO;
import com.dailyfixer.model.Product;
import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;

@MultipartConfig
public class EditProductServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("productId"));
            String name = request.getParameter("name");
            String type = request.getParameter("type");
            double quantity = Double.parseDouble(request.getParameter("quantity"));
            String quantityUnit = request.getParameter("quantityUnit");
            double price = Double.parseDouble(request.getParameter("price"));
            Part filePart = request.getPart("image");
            byte[] image = null;
            if(filePart != null && filePart.getSize() > 0) {
                image = filePart.getInputStream().readAllBytes();
            } else {
                image = new ProductDAO().getProductById(id).getImage();
            }

            Product p = new Product();
            p.setProductId(id);
            p.setName(name);
            p.setType(type);
            p.setQuantity(quantity);
            p.setQuantityUnit(quantityUnit);
            p.setPrice(price);
            p.setImage(image);

            new ProductDAO().updateProduct(p);
            response.sendRedirect("ListProductsServlet");
        } catch (Exception e) { e.printStackTrace(); }
    }
}
