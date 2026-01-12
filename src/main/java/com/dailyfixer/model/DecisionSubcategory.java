package com.dailyfixer.model;

import java.sql.Timestamp;

public class DecisionSubcategory {
    private int subcategoryId;
    private int categoryId;
    private String name;
    private Timestamp createdAt;

    public int getSubcategoryId() { return subcategoryId; }
    public void setSubcategoryId(int subcategoryId) { this.subcategoryId = subcategoryId; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
