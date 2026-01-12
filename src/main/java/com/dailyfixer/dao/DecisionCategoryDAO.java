package com.dailyfixer.dao;

import com.dailyfixer.model.DecisionCategory;
import com.dailyfixer.model.DecisionSubcategory;
import com.dailyfixer.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DecisionCategoryDAO {

    public List<DecisionCategory> getAllCategories() {
        List<DecisionCategory> categories = new ArrayList<>();
        String sql = "SELECT * FROM decision_categories ORDER BY name";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                DecisionCategory cat = new DecisionCategory();
                cat.setCategoryId(rs.getInt("category_id"));
                cat.setName(rs.getString("name"));
                cat.setCreatedAt(rs.getTimestamp("created_at"));
                categories.add(cat);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return categories;
    }

    public DecisionCategory getCategoryById(int categoryId) {
        String sql = "SELECT * FROM decision_categories WHERE category_id = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    DecisionCategory cat = new DecisionCategory();
                    cat.setCategoryId(rs.getInt("category_id"));
                    cat.setName(rs.getString("name"));
                    cat.setCreatedAt(rs.getTimestamp("created_at"));
                    return cat;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public int addCategory(String name) {
        String sql = "INSERT INTO decision_categories (name) VALUES (?)";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, name);
            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public List<DecisionSubcategory> getSubcategoriesByCategoryId(int categoryId) {
        List<DecisionSubcategory> subcategories = new ArrayList<>();
        String sql = "SELECT * FROM decision_subcategories WHERE category_id = ? ORDER BY name";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DecisionSubcategory sub = new DecisionSubcategory();
                    sub.setSubcategoryId(rs.getInt("subcategory_id"));
                    sub.setCategoryId(rs.getInt("category_id"));
                    sub.setName(rs.getString("name"));
                    sub.setCreatedAt(rs.getTimestamp("created_at"));
                    subcategories.add(sub);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return subcategories;
    }

    public DecisionSubcategory getSubcategoryById(int subcategoryId) {
        String sql = "SELECT * FROM decision_subcategories WHERE subcategory_id = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, subcategoryId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    DecisionSubcategory sub = new DecisionSubcategory();
                    sub.setSubcategoryId(rs.getInt("subcategory_id"));
                    sub.setCategoryId(rs.getInt("category_id"));
                    sub.setName(rs.getString("name"));
                    sub.setCreatedAt(rs.getTimestamp("created_at"));
                    return sub;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public int addSubcategory(int categoryId, String name) {
        String sql = "INSERT INTO decision_subcategories (category_id, name) VALUES (?, ?)";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, categoryId);
            ps.setString(2, name);
            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }
}
