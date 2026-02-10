package com.dailyfixer.model;

import java.sql.Timestamp;

/**
 * Model for user_notifications table (user dashboard notifications).
 */
public class UserNotification {

    public static final String TYPE_ORDER_SUCCESS = "ORDER_SUCCESS";
    public static final String TYPE_ORDER_UNSUCCESSFUL = "ORDER_UNSUCCESSFUL";

    private int id;
    private int userId;
    private String type;
    private String orderId;
    private String title;
    private String body;
    private boolean read;
    private Timestamp createdAt;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public String getOrderId() { return orderId; }
    public void setOrderId(String orderId) { this.orderId = orderId; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getBody() { return body; }
    public void setBody(String body) { this.body = body; }
    public boolean isRead() { return read; }
    public void setRead(boolean read) { this.read = read; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
