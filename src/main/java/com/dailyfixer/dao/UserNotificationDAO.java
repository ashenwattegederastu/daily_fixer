package com.dailyfixer.dao;

import com.dailyfixer.model.UserNotification;
import com.dailyfixer.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for user_notifications table.
 */
public class UserNotificationDAO {

    private static final String INSERT = "INSERT INTO user_notifications (user_id, type, order_id, title, body, is_read) VALUES (?, ?, ?, ?, ?, 0)";
    private static final String SELECT_BY_USER = "SELECT id, user_id, type, order_id, title, body, is_read, created_at FROM user_notifications WHERE user_id = ? ORDER BY created_at DESC";
    private static final String EXISTS_ORDER_SUCCESS = "SELECT 1 FROM user_notifications WHERE order_id = ? AND type = ? LIMIT 1";
    private static final String EXISTS_ORDER_SUCCESS_FOR_USER = "SELECT 1 FROM user_notifications WHERE user_id = ? AND order_id = ? AND type = ? LIMIT 1";
    private static final String EXISTS_ORDER_BY_TYPE = "SELECT 1 FROM user_notifications WHERE order_id = ? AND type = ? LIMIT 1";
    private static final String EXISTS_ORDER_BY_TYPE_FOR_USER = "SELECT 1 FROM user_notifications WHERE user_id = ? AND order_id = ? AND type = ? LIMIT 1";

    public boolean insert(UserNotification n) {
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(INSERT);
            stmt.setInt(1, n.getUserId());
            stmt.setString(2, n.getType() != null ? n.getType() : UserNotification.TYPE_ORDER_SUCCESS);
            stmt.setString(3, n.getOrderId());
            stmt.setString(4, n.getTitle());
            stmt.setString(5, n.getBody());
            return stmt.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("UserNotificationDAO insert: " + e.getMessage());
            return false;
        } finally {
            closeQuietly(stmt);
            closeQuietly(conn);
        }
    }

    public boolean existsOrderSuccessNotification(String orderId) {
        if (orderId == null || orderId.isEmpty()) return false;
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(EXISTS_ORDER_SUCCESS);
            stmt.setString(1, orderId);
            stmt.setString(2, UserNotification.TYPE_ORDER_SUCCESS);
            rs = stmt.executeQuery();
            return rs.next();
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("UserNotificationDAO existsOrderSuccess: " + e.getMessage());
            return false;
        } finally {
            closeQuietly(rs);
            closeQuietly(stmt);
            closeQuietly(conn);
        }
    }

    /** Returns true if a notification of the given type already exists for this order. */
    public boolean existsNotificationByType(String orderId, String type) {
        if (orderId == null || orderId.isEmpty() || type == null || type.isEmpty()) return false;
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(EXISTS_ORDER_BY_TYPE);
            stmt.setString(1, orderId);
            stmt.setString(2, type);
            rs = stmt.executeQuery();
            return rs.next();
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("UserNotificationDAO existsNotificationByType: " + e.getMessage());
            return false;
        } finally {
            closeQuietly(rs);
            closeQuietly(stmt);
            closeQuietly(conn);
        }
    }

    /** Returns true if this user already has a notification of the given type for this order. */
    public boolean existsNotificationByTypeForUser(int userId, String orderId, String type) {
        if (orderId == null || orderId.isEmpty() || type == null || type.isEmpty()) return false;
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(EXISTS_ORDER_BY_TYPE_FOR_USER);
            stmt.setInt(1, userId);
            stmt.setString(2, orderId);
            stmt.setString(3, type);
            rs = stmt.executeQuery();
            return rs.next();
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("UserNotificationDAO existsNotificationByTypeForUser: " + e.getMessage());
            return false;
        } finally {
            closeQuietly(rs);
            closeQuietly(stmt);
            closeQuietly(conn);
        }
    }

    /** Returns true if this user already has an ORDER_SUCCESS notification for this order. */
    public boolean existsOrderSuccessNotificationForUser(int userId, String orderId) {
        if (orderId == null || orderId.isEmpty()) return false;
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(EXISTS_ORDER_SUCCESS_FOR_USER);
            stmt.setInt(1, userId);
            stmt.setString(2, orderId);
            stmt.setString(3, UserNotification.TYPE_ORDER_SUCCESS);
            rs = stmt.executeQuery();
            return rs.next();
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("UserNotificationDAO existsOrderSuccessForUser: " + e.getMessage());
            return false;
        } finally {
            closeQuietly(rs);
            closeQuietly(stmt);
            closeQuietly(conn);
        }
    }

    public List<UserNotification> findByUserId(int userId) {
        List<UserNotification> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(SELECT_BY_USER);
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("UserNotificationDAO findByUserId: " + e.getMessage());
        } finally {
            closeQuietly(rs);
            closeQuietly(stmt);
            closeQuietly(conn);
        }
        return list;
    }

    private UserNotification mapRow(ResultSet rs) throws SQLException {
        UserNotification n = new UserNotification();
        n.setId(rs.getInt("id"));
        n.setUserId(rs.getInt("user_id"));
        n.setType(rs.getString("type"));
        n.setOrderId(rs.getString("order_id"));
        n.setTitle(rs.getString("title"));
        n.setBody(rs.getString("body"));
        n.setRead(rs.getInt("is_read") == 1);
        n.setCreatedAt(rs.getTimestamp("created_at"));
        return n;
    }

    private void closeQuietly(AutoCloseable c) {
        if (c != null) try { c.close(); } catch (Exception e) { }
    }
}
