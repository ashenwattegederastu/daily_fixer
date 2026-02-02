package com.dailyfixer.dao;

import java.sql.*;
import java.util.*;

import com.dailyfixer.model.Product;
import com.dailyfixer.util.DBConnection;

public class ProductDAO {

    public void addProduct(Product p) throws Exception {
        String sql = "INSERT INTO products (name, type, quantity, quantity_unit, price, image, store_username, description) VALUES (?, ?, ?, ?, ?, ?, ?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, p.getName());
            ps.setString(2, p.getType());
            ps.setDouble(3, p.getQuantity());
            ps.setString(4, p.getQuantityUnit());
            ps.setDouble(5, p.getPrice());
            ps.setBytes(6, p.getImage());
            ps.setString(7, p.getStoreUsername());
            ps.setString(8, p.getDescription());
            ps.executeUpdate();
        }
    }

    public List<Product> getAllProducts(String storeUsername) throws Exception {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE store_username=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, storeUsername);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product();
                p.setProductId(rs.getInt("product_id"));
                p.setName(rs.getString("name"));
                p.setType(rs.getString("type"));
                p.setQuantity(rs.getInt("quantity"));
                p.setQuantityUnit(rs.getString("quantity_unit"));
                p.setPrice(rs.getDouble("price"));
                p.setImage(rs.getBytes("image"));
                p.setDescription(rs.getString("description"));
                list.add(p);
            }
        }
        return list;
    }

    public Product getProductById(int id) throws Exception {
        Product p = null;
        String sql = "SELECT * FROM products WHERE product_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                p = new Product();
                p.setProductId(rs.getInt("product_id"));
                p.setName(rs.getString("name"));
                p.setType(rs.getString("type"));
                p.setQuantity(rs.getInt("quantity"));
                p.setQuantityUnit(rs.getString("quantity_unit"));
                p.setPrice(rs.getDouble("price"));
                p.setImage(rs.getBytes("image"));
                p.setDescription(rs.getString("description"));
            }
        }
        return p;
    }

    public void updateProduct(Product p) throws Exception {
        String sql = "UPDATE products SET name=?, type=?, quantity=?, quantity_unit=?, price=?, image=?, description=? WHERE product_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, p.getName());
            ps.setString(2, p.getType());
            ps.setDouble(3, p.getQuantity());
            ps.setString(4, p.getQuantityUnit());
            ps.setDouble(5, p.getPrice());
            ps.setBytes(6, p.getImage());
            ps.setString(7, p.getDescription());
            ps.setInt(8, p.getProductId());
            ps.executeUpdate();
        }
    }

    public void deleteProduct(int id) throws Exception {
        String sql = "DELETE FROM products WHERE product_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }


    public List<Product> getProductsByCategory(String category) throws Exception {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE type = ?"; // make sure your DB has a 'description' column

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, category);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Product p = new Product();
                p.setProductId(rs.getInt("product_id"));
                p.setName(rs.getString("name"));
                p.setType(rs.getString("type"));
                p.setQuantity(rs.getInt("quantity"));
                p.setQuantityUnit(rs.getString("quantity_unit"));
                p.setPrice(rs.getDouble("price"));
                p.setImage(rs.getBytes("image"));
                p.setStoreUsername(rs.getString("store_username"));
                p.setDescription(rs.getString("description")); // <-- populate description
                list.add(p);
            }
        }
        return list;
    }

}