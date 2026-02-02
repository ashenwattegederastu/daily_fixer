package com.dailyfixer.user;

import com.dailyfixer.model.CartItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;

@WebServlet("/removeFromCart")
public class RemoveCartServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        try {
            String productIdStr = request.getParameter("productId");
            if (productIdStr == null || productIdStr.isEmpty()) {
                out.print("{\"error\":\"Missing productId\"}");
                return;
            }

            int productId = Integer.parseInt(productIdStr);

            HttpSession session = request.getSession();
            Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");

            if (cart != null && cart.containsKey(productId)) {
                cart.remove(productId);
            }

            session.setAttribute("cart", cart);

            // Calculate updated cart count
            int cartCount = 0;
            if (cart != null) {
                for (CartItem ci : cart.values()) cartCount += ci.getQuantity();
            }

            out.print("{\"cartCount\":" + cartCount + "}");
        } catch (Exception e) {
            out.print("{\"error\":\"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }
}

