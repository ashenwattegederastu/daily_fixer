package com.dailyfixer.util;

import com.dailyfixer.dao.OrderDAO;
import com.dailyfixer.dao.UserDAO;
import com.dailyfixer.dao.UserNotificationDAO;
import com.dailyfixer.model.Order;
import com.dailyfixer.model.User;
import com.dailyfixer.model.UserNotification;

/**
 * Creates a user dashboard notification when an order is successfully paid.
 */
public final class OrderNotificationHelper {

    /**
     * Creates an ORDER_SUCCESS notification for the given user (e.g. logged-in user on success page).
     * Use this when the customer may have used a different email at checkout than their registration email.
     * One notification per (userId, orderId) — no duplicate for same user and order.
     */
    public static boolean createOrderSuccessNotificationForUser(int userId, String orderId) {
        if (orderId == null || orderId.trim().isEmpty()) return false;
        OrderDAO orderDAO = new OrderDAO();
        UserNotificationDAO notifDAO = new UserNotificationDAO();

        if (notifDAO.existsOrderSuccessNotificationForUser(userId, orderId)) return false;
        Order order = orderDAO.findOrderById(orderId);
        if (order == null) return false;
        String status = order.getStatus() != null ? order.getStatus().trim() : "";
        if (!"PAID".equalsIgnoreCase(status)) return false;

        UserNotification n = new UserNotification();
        n.setUserId(userId);
        n.setType(UserNotification.TYPE_ORDER_SUCCESS);
        n.setOrderId(orderId);
        n.setTitle("Your order is successful");
        n.setBody(buildOrderDetailsBody(order));
        boolean ok = notifDAO.insert(n);
        if (ok) System.out.println("Order success notification created for user " + userId + ", order " + orderId);
        return ok;
    }

    /**
     * If the order is paid and the customer email matches a registered user,
     * creates an ORDER_SUCCESS notification (once per order). Used by NotifyServlet.
     */
    public static boolean createOrderSuccessNotificationIfNeeded(String orderId) {
        if (orderId == null || orderId.trim().isEmpty()) return false;
        OrderDAO orderDAO = new OrderDAO();
        UserNotificationDAO notifDAO = new UserNotificationDAO();
        UserDAO userDAO = new UserDAO();

        if (notifDAO.existsOrderSuccessNotification(orderId)) return false;
        Order order = orderDAO.findOrderById(orderId);
        if (order == null) return false;
        String status = order.getStatus() != null ? order.getStatus().trim() : "";
        if (!"PAID".equalsIgnoreCase(status)) return false;
        String email = order.getEmail();
        if (email == null || email.trim().isEmpty()) return false;
        User user;
        try {
            user = userDAO.getUserByEmail(email.trim());
        } catch (Exception e) {
            System.err.println("OrderNotificationHelper getUserByEmail: " + e.getMessage());
            return false;
        }
        if (user == null) return false;

        UserNotification n = new UserNotification();
        n.setUserId(user.getUserId());
        n.setType(UserNotification.TYPE_ORDER_SUCCESS);
        n.setOrderId(orderId);
        n.setTitle("Your order is successful");
        n.setBody(buildOrderDetailsBody(order));
        boolean ok = notifDAO.insert(n);
        if (ok) System.out.println("Order success notification created for user " + user.getUserId() + ", order " + orderId);
        return ok;
    }

    /**
     * Creates an ORDER_UNSUCCESSFUL notification for the given user (e.g. logged-in user on cancel page).
     */
    public static boolean createOrderUnsuccessfulNotificationForUser(int userId, String orderId) {
        if (orderId == null || orderId.trim().isEmpty()) return false;
        OrderDAO orderDAO = new OrderDAO();
        UserNotificationDAO notifDAO = new UserNotificationDAO();

        if (notifDAO.existsNotificationByTypeForUser(userId, orderId, UserNotification.TYPE_ORDER_UNSUCCESSFUL)) return false;
        Order order = orderDAO.findOrderById(orderId);
        if (order == null) return false;
        String status = order.getStatus() != null ? order.getStatus().trim() : "";
        if (!"FAILED".equalsIgnoreCase(status) && !"CANCELLED".equalsIgnoreCase(status)) return false;

        UserNotification n = new UserNotification();
        n.setUserId(userId);
        n.setType(UserNotification.TYPE_ORDER_UNSUCCESSFUL);
        n.setOrderId(orderId);
        n.setTitle("Order unsuccessful");
        n.setBody(buildOrderDetailsBody(order));
        boolean ok = notifDAO.insert(n);
        if (ok) System.out.println("Order unsuccessful notification created for user " + userId + ", order " + orderId);
        return ok;
    }

    /**
     * When order is failed/cancelled and customer email matches a registered user,
     * creates an ORDER_UNSUCCESSFUL notification. Used by NotifyServlet.
     */
    public static boolean createOrderUnsuccessfulNotificationIfNeeded(String orderId) {
        if (orderId == null || orderId.trim().isEmpty()) return false;
        OrderDAO orderDAO = new OrderDAO();
        UserNotificationDAO notifDAO = new UserNotificationDAO();
        UserDAO userDAO = new UserDAO();

        if (notifDAO.existsNotificationByType(orderId, UserNotification.TYPE_ORDER_UNSUCCESSFUL)) return false;
        Order order = orderDAO.findOrderById(orderId);
        if (order == null) return false;
        String status = order.getStatus() != null ? order.getStatus().trim() : "";
        if (!"FAILED".equalsIgnoreCase(status) && !"CANCELLED".equalsIgnoreCase(status)) return false;
        String email = order.getEmail();
        if (email == null || email.trim().isEmpty()) return false;
        User user;
        try {
            user = userDAO.getUserByEmail(email.trim());
        } catch (Exception e) {
            System.err.println("OrderNotificationHelper getUserByEmail (unsuccessful): " + e.getMessage());
            return false;
        }
        if (user == null) return false;

        UserNotification n = new UserNotification();
        n.setUserId(user.getUserId());
        n.setType(UserNotification.TYPE_ORDER_UNSUCCESSFUL);
        n.setOrderId(orderId);
        n.setTitle("Order unsuccessful");
        n.setBody(buildOrderDetailsBody(order));
        boolean ok = notifDAO.insert(n);
        if (ok) System.out.println("Order unsuccessful notification created for user " + user.getUserId() + ", order " + orderId);
        return ok;
    }

    private static String buildOrderDetailsBody(Order order) {
        StringBuilder sb = new StringBuilder();
        sb.append("Order ID: ").append(order.getOrderId()).append("\n");
        sb.append("Amount: ").append(order.getFormattedAmount()).append(" ").append(order.getCurrency()).append("\n");
        if (order.getProductName() != null && !order.getProductName().isEmpty())
            sb.append("Items: ").append(order.getProductName());
        return sb.toString();
    }
}
