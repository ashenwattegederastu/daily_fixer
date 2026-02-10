package com.dailyfixer.servlet;

import com.dailyfixer.dao.OrderDAO;
import com.dailyfixer.dao.UserNotificationDAO;
import com.dailyfixer.model.Order;
import com.dailyfixer.model.OrderItem;
import com.dailyfixer.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.SimpleDateFormat;
import java.util.List;

/**
 * Serves a print-friendly receipt for a paid order.
 * GET: ?order_id=xxx — user must be logged in; access if order email matches user email
 * or user has an ORDER_SUCCESS notification for this order (e.g. placed with different email).
 */
@WebServlet("/receipt")
public class ReceiptServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();
    private final UserNotificationDAO userNotificationDAO = new UserNotificationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String orderId = request.getParameter("order_id");
        if (orderId == null || orderId.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing order_id");
            return;
        }

        User user = (User) request.getSession().getAttribute("currentUser");
        if (user == null || user.getEmail() == null) {
            response.sendRedirect(request.getContextPath() + "/pages/shared/login.jsp?redirect=receipt&order_id=" + orderId);
            return;
        }

        Order order = orderDAO.findOrderById(orderId);
        if (order == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Order not found");
            return;
        }
        String status = order.getStatus() != null ? order.getStatus().trim() : "";
        if (!"PAID".equalsIgnoreCase(status)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Receipt available only for paid orders");
            return;
        }
        boolean emailMatch = user.getEmail() != null && order.getEmail() != null
                && user.getEmail().trim().equalsIgnoreCase(order.getEmail().trim());
        boolean hasNotification = userNotificationDAO.existsOrderSuccessNotificationForUser(user.getUserId(), orderId);
        if (!emailMatch && !hasNotification) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "You do not have access to this receipt");
            return;
        }

        List<OrderItem> items = orderDAO.getOrderItemsByOrderId(orderId);
        String dateStr = order.getCreatedAt() != null
                ? new SimpleDateFormat("yyyy-MM-dd HH:mm").format(order.getCreatedAt())
                : "N/A";
        String customerName = order.getFullName();
        BigDecimal total = order.getAmount() != null ? order.getAmount() : BigDecimal.ZERO;
        String currency = order.getCurrency() != null ? order.getCurrency() : "LKR";

        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.print("<!DOCTYPE html><html lang=\"en\"><head><meta charset=\"UTF-8\"><meta name=\"viewport\" content=\"width=device-width,initial-scale=1\">");
        out.print("<title>Receipt - Order " + esc(orderId) + "</title>");
        out.print("<style>");
        out.print("body{font-family:Inter,sans-serif;max-width:600px;margin:24px auto;padding:20px;color:#111;}");
        out.print("h1{font-size:1.25rem;margin-bottom:8px;}");
        out.print(".meta{color:#555;font-size:0.9rem;margin-bottom:20px;}");
        out.print("table{width:100%;border-collapse:collapse;margin:16px 0;}");
        out.print("th,td{border:1px solid #ddd;padding:10px;text-align:left;}");
        out.print("th{background:#f5f5f5;}");
        out.print(".total{font-weight:700;font-size:1.1rem;margin-top:16px;}");
        out.print(".no-print{margin-top:24px;}");
        out.print("@media print{.no-print{display:none !important;}}");
        out.print("</style></head><body>");
        out.print("<h1>Daily Fixer - Order Receipt</h1>");
        out.print("<div class=\"meta\">Order ID: " + esc(orderId) + " &nbsp;|&nbsp; Date: " + esc(dateStr) + "</div>");
        out.print("<p><strong>Customer:</strong> " + esc(customerName) + "</p>");
        out.print("<p><strong>Email:</strong> " + esc(order.getEmail()) + "</p>");
        out.print("<p><strong>Address:</strong> " + esc(order.getAddress()) + ", " + esc(order.getCity()) + "</p>");
        out.print("<table><thead><tr><th>Item</th><th>Qty</th><th>Unit Price</th><th>Total</th></tr></thead><tbody>");
        if (items != null) {
            for (OrderItem item : items) {
                String name = item.getProductName() != null ? item.getProductName() : "Item";
                int qty = item.getQuantity();
                BigDecimal unit = item.getUnitPrice() != null ? item.getUnitPrice() : BigDecimal.ZERO;
                BigDecimal lineTotal = item.getTotalPrice() != null ? item.getTotalPrice() : unit.multiply(BigDecimal.valueOf(qty));
                out.print("<tr><td>" + esc(name) + "</td><td>" + qty + "</td><td>" + currency + " " + unit.setScale(2, RoundingMode.HALF_UP) + "</td><td>" + currency + " " + lineTotal.setScale(2, RoundingMode.HALF_UP) + "</td></tr>");
            }
        }
        out.print("</tbody></table>");
        out.print("<div class=\"total\">Total: " + esc(currency) + " " + total.setScale(2, RoundingMode.HALF_UP) + "</div>");
        out.print("<div class=\"no-print\"><button onclick=\"window.print()\">Print / Save as PDF</button></div>");
        out.print("</body></html>");
        out.flush();
    }

    private static String esc(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;");
    }
}
