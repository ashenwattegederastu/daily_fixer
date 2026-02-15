package com.dailyfixer.dao;

import com.dailyfixer.model.Order;
import com.dailyfixer.model.OrderItem;
import com.dailyfixer.model.ProductSales;
import com.dailyfixer.util.TestDBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Test helper for OrderDAO that uses H2 in-memory database.
 * Wraps the production OrderDAO methods but uses TestDBConnection.
 */
public class OrderDAOTestHelper {

    public boolean createOrder(Order order) throws Exception {
        String sql = "INSERT INTO orders (order_id, customer_name, email, phone, address, city, " +
                "total_amount, currency, status, store_username, product_name, buyer_id) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = TestDBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // Combine first name and last name into customer_name
            String customerName = order.getFirstName();
            if (order.getLastName() != null && !order.getLastName().isEmpty()) {
                customerName += " " + order.getLastName();
            }

            ps.setString(1, order.getOrderId());
            ps.setString(2, customerName);
            ps.setString(3, order.getEmail());
            ps.setString(4, order.getPhone());
            ps.setString(5, order.getAddress());
            ps.setString(6, order.getCity());
            ps.setBigDecimal(7, order.getAmount());
            ps.setString(8, order.getCurrency());
            ps.setString(9, order.getStatus());
            ps.setString(10, order.getStoreUsername());
            ps.setString(11, order.getProductName());
            if (order.getBuyerId() != null) {
                ps.setInt(12, order.getBuyerId());
            } else {
                ps.setNull(12, Types.INTEGER);
            }

            return ps.executeUpdate() > 0;
        }
    }

    public Order findOrderById(String orderId) throws Exception {
        String sql = "SELECT * FROM orders WHERE order_id = ?";

        try (Connection conn = TestDBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, orderId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToOrder(rs);
                }
            }
        }
        return null;
    }

    public boolean updateOrderStatus(String orderId, String status, String payherePaymentId) throws Exception {
        String sql = "UPDATE orders SET status = ?, payhere_payment_id = ? WHERE order_id = ?";

        try (Connection conn = TestDBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setString(2, payherePaymentId);
            ps.setString(3, orderId);
            
            return ps.executeUpdate() > 0;
        }
    }

    public boolean updateStatus(String orderId, String status) throws Exception {
        String sql = "UPDATE orders SET status = ? WHERE order_id = ?";

        try (Connection conn = TestDBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setString(2, orderId);
            
            return ps.executeUpdate() > 0;
        }
    }

    public List<Order> getOrdersByStatus(String status) throws Exception {
        String sql = "SELECT * FROM orders WHERE UPPER(TRIM(status)) = UPPER(TRIM(?)) ORDER BY created_at DESC";
        List<Order> orders = new ArrayList<>();

        try (Connection conn = TestDBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    orders.add(mapResultSetToOrder(rs));
                }
            }
        }
        return orders;
    }

    public List<Order> getOrdersByStatusAndStore(String status, String storeUsername) throws Exception {
        String sql = "SELECT * FROM orders WHERE UPPER(TRIM(status)) = UPPER(TRIM(?)) AND store_username = ? ORDER BY created_at DESC";
        List<Order> orders = new ArrayList<>();

        try (Connection conn = TestDBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setString(2, storeUsername);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    orders.add(mapResultSetToOrder(rs));
                }
            }
        }
        return orders;
    }

    public List<Order> getAllOrdersByStore(String storeUsername) throws Exception {
        String sql = "SELECT * FROM orders WHERE store_username = ? AND UPPER(TRIM(status)) IN ('PAID','PENDING','PROCESSING','OUT_FOR_DELIVERY','DELIVERED') ORDER BY created_at DESC";
        List<Order> orders = new ArrayList<>();

        try (Connection conn = TestDBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, storeUsername);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    orders.add(mapResultSetToOrder(rs));
                }
            }
        }
        return orders;
    }

    public List<Order> getOrdersByBuyerId(int buyerId) throws Exception {
        String sql = "SELECT * FROM orders WHERE buyer_id = ? ORDER BY created_at DESC";
        List<Order> orders = new ArrayList<>();

        try (Connection conn = TestDBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, buyerId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    orders.add(mapResultSetToOrder(rs));
                }
            }
        }
        return orders;
    }

    public boolean createOrderItem(OrderItem orderItem) throws Exception {
        String sql = "INSERT INTO order_items (order_id, store_id, product_id, variant_id, " +
                "product_name, quantity, unit_price, total_price, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = TestDBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, orderItem.getOrderId());
            ps.setInt(2, orderItem.getStoreId());
            ps.setInt(3, orderItem.getProductId());
            if (orderItem.getVariantId() != null) {
                ps.setInt(4, orderItem.getVariantId());
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            ps.setString(5, orderItem.getProductName());
            ps.setInt(6, orderItem.getQuantity());
            ps.setBigDecimal(7, orderItem.getUnitPrice());
            ps.setBigDecimal(8, orderItem.getTotalPrice());
            ps.setString(9, orderItem.getStatus());
            
            return ps.executeUpdate() > 0;
        }
    }

    public List<OrderItem> getOrderItemsByOrderId(String orderId) throws Exception {
        String sql = "SELECT * FROM order_items WHERE order_id = ? ORDER BY id";
        List<OrderItem> items = new ArrayList<>();

        try (Connection conn = TestDBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, orderId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    items.add(mapResultSetToOrderItem(rs));
                }
            }
        }
        return items;
    }

    public List<OrderItem> getOrderItemsByStoreAndStatus(int storeId, String status) throws Exception {
        String sql = "SELECT oi.* FROM order_items oi " +
                "JOIN orders o ON oi.order_id = o.order_id " +
                "WHERE oi.store_id = ? AND UPPER(TRIM(o.status)) = UPPER(TRIM(?)) " +
                "ORDER BY o.created_at DESC, oi.id";
        List<OrderItem> items = new ArrayList<>();

        try (Connection conn = TestDBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, storeId);
            ps.setString(2, status);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    items.add(mapResultSetToOrderItem(rs));
                }
            }
        }
        return items;
    }

    public List<ProductSales> getProductSalesByStore(String storeUsername) throws Exception {
        String sql = "SELECT oi.product_id, oi.product_name, SUM(oi.quantity) AS total_qty " +
                "FROM order_items oi JOIN orders o ON oi.order_id = o.order_id " +
                "WHERE o.store_username = ? AND UPPER(TRIM(o.status)) IN ('PAID','PENDING','PROCESSING','OUT_FOR_DELIVERY','DELIVERED') " +
                "GROUP BY oi.product_id, oi.product_name ORDER BY total_qty DESC";
        List<ProductSales> salesList = new ArrayList<>();

        try (Connection conn = TestDBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, storeUsername);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProductSales sales = new ProductSales();
                    sales.setProductId(rs.getInt("product_id"));
                    sales.setProductName(rs.getString("product_name"));
                    sales.setQuantitySold(rs.getInt("total_qty"));
                    salesList.add(sales);
                }
            }
        }
        return salesList;
    }

    private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setOrderId(rs.getString("order_id"));
        
        // Parse customer_name into firstName and lastName
        String customerName = rs.getString("customer_name");
        if (customerName != null && !customerName.isEmpty()) {
            String[] parts = customerName.split(" ", 2);
            order.setFirstName(parts[0]);
            if (parts.length > 1) {
                order.setLastName(parts[1]);
            }
        }
        
        order.setEmail(rs.getString("email"));
        order.setPhone(rs.getString("phone"));
        order.setAddress(rs.getString("address"));
        order.setCity(rs.getString("city"));
        order.setAmount(rs.getBigDecimal("total_amount"));
        order.setCurrency(rs.getString("currency"));
        order.setStatus(rs.getString("status"));
        order.setPayherePaymentId(rs.getString("payhere_payment_id"));
        order.setStoreUsername(rs.getString("store_username"));
        order.setProductName(rs.getString("product_name"));
        
        int buyerId = rs.getInt("buyer_id");
        if (!rs.wasNull()) {
            order.setBuyerId(buyerId);
        }
        
        order.setCreatedAt(rs.getTimestamp("created_at"));
        order.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        return order;
    }

    private OrderItem mapResultSetToOrderItem(ResultSet rs) throws SQLException {
        OrderItem item = new OrderItem();
        item.setId(rs.getInt("id"));
        item.setOrderId(rs.getString("order_id"));
        item.setStoreId(rs.getInt("store_id"));
        item.setProductId(rs.getInt("product_id"));
        
        int variantId = rs.getInt("variant_id");
        if (!rs.wasNull()) {
            item.setVariantId(variantId);
        }
        
        item.setProductName(rs.getString("product_name"));
        item.setQuantity(rs.getInt("quantity"));
        item.setUnitPrice(rs.getBigDecimal("unit_price"));
        item.setTotalPrice(rs.getBigDecimal("total_price"));
        item.setStatus(rs.getString("status"));
        item.setCreatedAt(rs.getTimestamp("created_at"));
        
        return item;
    }
}
