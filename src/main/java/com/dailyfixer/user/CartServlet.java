package com.dailyfixer.user;

import com.dailyfixer.dao.ProductDAO;
import com.dailyfixer.model.CartItem;
import com.dailyfixer.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/addToCart")
public class CartServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();

        Map<Integer, CartItem> cart;
        Object obj = session.getAttribute("cart");

        if (obj instanceof Map) {
            cart = (Map<Integer, CartItem>) obj;
        } else {
            cart = new HashMap<>();
        }

        try {
            String productIdStr = request.getParameter("productId");
            String quantityStr = request.getParameter("quantity");

            if (productIdStr == null || quantityStr == null ||
                    productIdStr.isBlank() || quantityStr.isBlank()) {
                out.print("{\"error\":\"Invalid request\"}");
                return;
            }

            int productId = Integer.parseInt(productIdStr);
            int quantity = Integer.parseInt(quantityStr);

            ProductDAO dao = new ProductDAO();
            Product product = dao.getProductById(productId);

            if (product == null) {
                out.print("{\"error\":\"Product not found\"}");
                return;
            }

            // 🚨 OUT OF STOCK CHECK (MOST IMPORTANT)
            if (product.getQuantity() <= 0) {
                out.print("{\"error\":\"Product is out of stock\"}");
                return;
            }

            if (quantity > product.getQuantity()) {
                out.print("{\"error\":\"Requested quantity exceeds stock\"}");
                return;
            }

            CartItem item = cart.get(productId);

            if (item == null) {
                item = new CartItem(
                        product.getProductId(),
                        product.getName(),
                        product.getPrice(),
                        quantity,
                        product.getImageBase64()
                );
                cart.put(productId, item);
            } else {
                int newQty = item.getQuantity() + quantity;
                item.setQuantity(Math.min(newQty, product.getQuantity()));
            }

            session.setAttribute("cart", cart);

            int cartCount = cart.values()
                    .stream()
                    .mapToInt(CartItem::getQuantity)
                    .sum();

            out.print("{\"cartCount\":" + cartCount + "}");

        } catch (Exception e) {
            out.print("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }
}
