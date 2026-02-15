package com.dailyfixer.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Order model class representing a customer order.
 */
public class Order {

    private String orderId;
    private String firstName;
    private String lastName;
    private String email;
    private String phone;
    private String address;
    private String city;
    private String productName;
    private BigDecimal amount;
    private String currency;
    private String status;
    private String payherePaymentId;
    private String storeUsername; // Store username to filter orders by store
    private Integer buyerId; // User ID of the buyer (null for guest checkout)
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private String refundReason; // Reason for cancellation/refund
    private String refundNumber; // PayHere refund number
    private Timestamp refundedAt; // When the refund was processed

    // Default constructor
    public Order() {
        this.currency = "LKR";
        this.status = "PENDING";
    }

    // Constructor with essential fields
    public Order(String orderId, String firstName, String lastName, String email,
            String phone, String address, String city, String productName, BigDecimal amount) {
        this();
        this.orderId = orderId;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.phone = phone;
        this.address = address;
        this.city = city;
        this.productName = productName;
        this.amount = amount;
    }

    // ==================== Getters and Setters ====================

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPayherePaymentId() {
        return payherePaymentId;
    }

    public void setPayherePaymentId(String payherePaymentId) {
        this.payherePaymentId = payherePaymentId;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getStoreUsername() {
        return storeUsername;
    }

    public void setStoreUsername(String storeUsername) {
        this.storeUsername = storeUsername;
    }

    public Integer getBuyerId() {
        return buyerId;
    }

    public void setBuyerId(Integer buyerId) {
        this.buyerId = buyerId;
    }

    // Get full customer name
    public String getFullName() {
        return firstName + " " + lastName;
    }

    // Get formatted amount (2 decimal places)
    public String getFormattedAmount() {
        return String.format("%.2f", amount);
    }

    // ==================== Refund Fields ====================

    public String getRefundReason() {
        return refundReason;
    }

    public void setRefundReason(String refundReason) {
        this.refundReason = refundReason;
    }

    public String getRefundNumber() {
        return refundNumber;
    }

    public void setRefundNumber(String refundNumber) {
        this.refundNumber = refundNumber;
    }

    public Timestamp getRefundedAt() {
        return refundedAt;
    }

    public void setRefundedAt(Timestamp refundedAt) {
        this.refundedAt = refundedAt;
    }

    // ==================== Refund Helpers ====================

    /**
     * Check if the order can be cancelled/refunded.
     * Cancellable if status is PAID or PROCESSING.
     * Note: whether a PayHere refund API call is needed depends on
     * whether payherePaymentId is present — that logic is in RefundServlet.
     */
    public boolean isRefundable() {
        String s = status != null ? status.trim().toUpperCase() : "";
        return "PAID".equals(s) || "PROCESSING".equals(s);
    }

    /**
     * Check if the order is within the 1-hour cancellation window.
     * Users can cancel within 1 hour of the order being created.
     */
    public boolean isWithinCancelWindow() {
        if (createdAt == null)
            return false;
        long oneHourMs = 60 * 60 * 1000L;
        long elapsed = System.currentTimeMillis() - createdAt.getTime();
        return elapsed <= oneHourMs;
    }

    /**
     * Get remaining minutes in the cancel window (0 if expired).
     */
    public long getCancelWindowMinutesRemaining() {
        if (createdAt == null)
            return 0;
        long oneHourMs = 60 * 60 * 1000L;
        long elapsed = System.currentTimeMillis() - createdAt.getTime();
        long remaining = oneHourMs - elapsed;
        return remaining > 0 ? remaining / (60 * 1000L) : 0;
    }

    @Override

    public String toString() {
        return "Order{" +
                "orderId='" + orderId + '\'' +
                ", customer='" + getFullName() + '\'' +
                ", amount=" + amount +
                ", status='" + status + '\'' +
                '}';
    }
}
