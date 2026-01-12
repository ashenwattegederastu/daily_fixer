package com.dailyfixer.model;

import java.sql.Timestamp;

public class DecisionCategory {
    private int categoryId;
    private String name;
    private Timestamp createdAt;

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
