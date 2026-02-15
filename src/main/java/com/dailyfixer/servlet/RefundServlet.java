package com.dailyfixer.servlet;

import com.dailyfixer.dao.OrderDAO;
import com.dailyfixer.model.Order;
import com.dailyfixer.model.User;
import com.dailyfixer.service.PayHereRefundService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;

/**
 * Handles refund/cancellation requests for orders.
 *
 * Supports two types of cancellation:
 * 1. User cancellation — within 1 hour of purchase
 * 2. Store cancellation — no time restriction, for stock/unavailability issues
 *
 * POST /refund
 * Parameters:
 * orderId (required) — The order ID to refund
 * reason (optional) — Reason for cancellation
 * cancelledBy (required) — "user" or "store"
 */
@WebServlet("/refund")
public class RefundServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();
    private final PayHereRefundService refundService = new PayHereRefundService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        // ==================== Auth Check ====================

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"success\": false, \"message\": \"You must be logged in to cancel an order.\"}");
            out.flush();
            return;
        }

        // ==================== Parse Parameters ====================

        String orderId = request.getParameter("orderId");
        String reason = request.getParameter("reason");
        String cancelledBy = request.getParameter("cancelledBy");

        if (orderId == null || orderId.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"message\": \"Order ID is required.\"}");
            out.flush();
            return;
        }

        if (cancelledBy == null || cancelledBy.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"message\": \"cancelledBy parameter is required (user or store).\"}");
            out.flush();
            return;
        }

        cancelledBy = cancelledBy.trim().toLowerCase();
        if (!cancelledBy.equals("user") && !cancelledBy.equals("store")) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"message\": \"cancelledBy must be 'user' or 'store'.\"}");
            out.flush();
            return;
        }

        // ==================== Fetch Order ====================

        Order order = orderDAO.findOrderById(orderId.trim());
        if (order == null) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            out.print("{\"success\": false, \"message\": \"Order not found.\"}");
            out.flush();
            return;
        }

        System.out.println("RefundServlet: Processing refund for order " + orderId +
                " | cancelledBy=" + cancelledBy +
                " | status=" + order.getStatus() +
                " | paymentId=" + order.getPayherePaymentId());

        // ==================== Authorization ====================

        if (cancelledBy.equals("user")) {
            // User can only cancel their own orders
            if (order.getBuyerId() == null || order.getBuyerId() != currentUser.getUserId()) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                out.print("{\"success\": false, \"message\": \"You can only cancel your own orders.\"}");
                out.flush();
                return;
            }
        } else {
            // Store owner can only cancel orders belonging to their store
            String userRole = currentUser.getRole();
            String username = currentUser.getUsername();
            if (!"store".equalsIgnoreCase(userRole) && !"admin".equalsIgnoreCase(userRole)) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                out.print(
                        "{\"success\": false, \"message\": \"Only store owners can cancel orders on behalf of the store.\"}");
                out.flush();
                return;
            }
            if (order.getStoreUsername() == null || !order.getStoreUsername().equals(username)) {
                // Check if admin (admin can cancel any order)
                if (!"admin".equalsIgnoreCase(userRole)) {
                    response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                    out.print("{\"success\": false, \"message\": \"You can only cancel orders from your own store.\"}");
                    out.flush();
                    return;
                }
            }
        }

        // ==================== Refundability Check ====================

        if (!order.isRefundable()) {
            String statusMsg = order.getStatus() != null ? order.getStatus().toUpperCase() : "UNKNOWN";
            if ("REFUNDED".equals(statusMsg)) {
                out.print("{\"success\": false, \"message\": \"This order has already been refunded.\"}");
            } else if ("CANCELLED".equals(statusMsg)) {
                out.print("{\"success\": false, \"message\": \"This order has already been cancelled.\"}");
            } else if ("DELIVERED".equals(statusMsg)) {
                out.print("{\"success\": false, \"message\": \"Delivered orders cannot be refunded.\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"Order in status '" + statusMsg
                        + "' cannot be refunded.\"}");
            }
            out.flush();
            return;
        }

        // ==================== Time Window Check (User Only) ====================

        if (cancelledBy.equals("user")) {
            if (!order.isWithinCancelWindow()) {
                out.print(
                        "{\"success\": false, \"message\": \"The 1-hour cancellation window has expired. Please contact the store for assistance.\"}");
                out.flush();
                return;
            }
        }

        // ==================== Process Refund ====================

        // Set default reason
        if (reason == null || reason.trim().isEmpty()) {
            reason = cancelledBy.equals("user")
                    ? "Customer requested cancellation"
                    : "Store cancelled order";
        }

        boolean hasPayment = order.getPayherePaymentId() != null && !order.getPayherePaymentId().isEmpty();

        if (hasPayment) {
            // Has payment ID → call PayHere Refund API
            PayHereRefundService.RefundResult result = refundService.refundPayment(
                    order.getPayherePaymentId(), reason.trim());

            System.out.println("RefundServlet: Refund result for " + orderId + ": " + result);

            if (result.isSuccess()) {
                boolean updated = orderDAO.updateOrderRefund(
                        orderId, "REFUNDED", reason.trim(), result.getRefundNumber());

                if (updated) {
                    boolean stockRestored = orderDAO.restoreStockForOrder(orderId);
                    if (!stockRestored) {
                        System.err.println("Warning: Stock restoration may have failed for order " + orderId);
                    }
                    updateRelatedOrders(orderId, order, reason.trim(), result.getRefundNumber());

                    out.print("{\"success\": true, \"message\": \"Order cancelled and refund initiated successfully." +
                            (result.getRefundNumber() != null ? " Refund #" + result.getRefundNumber() : "") + "\"}");
                } else {
                    out.print(
                            "{\"success\": false, \"message\": \"Refund was processed by PayHere but failed to update order status. Please contact support.\"}");
                }
            } else {
                out.print("{\"success\": false, \"message\": \"" + escapeJsonString(result.getMessage()) + "\"}");
            }
        } else {
            // No payment ID → just cancel the order (no PayHere API call)
            System.out.println("RefundServlet: No PayHere payment ID for order " + orderId
                    + ", cancelling without refund API call.");

            boolean updated = orderDAO.updateOrderRefund(
                    orderId, "CANCELLED", reason.trim(), null);

            if (updated) {
                boolean stockRestored = orderDAO.restoreStockForOrder(orderId);
                if (!stockRestored) {
                    System.err.println("Warning: Stock restoration may have failed for order " + orderId);
                }

                out.print("{\"success\": true, \"message\": \"Order cancelled successfully.\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"Failed to update order status. Please try again.\"}");
            }
        }

        out.flush();
    }

    /**
     * If there are related orders (same buyer, same PayHere payment),
     * update them as well. This handles the case where multiple store orders
     * were created for a single PayHere payment.
     */
    private void updateRelatedOrders(String primaryOrderId, Order primaryOrder, String reason, String refundNumber) {
        try {
            if (primaryOrder.getBuyerId() != null) {
                java.util.List<Order> buyerOrders = orderDAO.getOrdersByBuyerId(primaryOrder.getBuyerId());
                for (Order relatedOrder : buyerOrders) {
                    if (!relatedOrder.getOrderId().equals(primaryOrderId)
                            && relatedOrder.getPayherePaymentId() != null
                            && relatedOrder.getPayherePaymentId().equals(primaryOrder.getPayherePaymentId())
                            && relatedOrder.isRefundable()) {
                        orderDAO.updateOrderRefund(relatedOrder.getOrderId(), "REFUNDED", reason, refundNumber);
                        orderDAO.restoreStockForOrder(relatedOrder.getOrderId());
                        System.out.println("Updated related order: " + relatedOrder.getOrderId());
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("Error updating related orders: " + e.getMessage());
        }
    }

    /**
     * Escape a string for safe inclusion in a JSON value.
     */
    private String escapeJsonString(String input) {
        if (input == null)
            return "";
        return input
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
