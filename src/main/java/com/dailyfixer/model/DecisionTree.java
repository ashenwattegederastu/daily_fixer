package com.dailyfixer.model;

import java.sql.Timestamp;

public class DecisionTree {
    private int treeId;
    private int userId;
    private int subcategoryId;
    private String treeName;
    private String description;
    private double avgRating;
    private int ratingCount;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Additional fields for display
    private String creatorUsername;
    private String categoryName;
    private String subcategoryName;

    public int getTreeId() { return treeId; }
    public void setTreeId(int treeId) { this.treeId = treeId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getSubcategoryId() { return subcategoryId; }
    public void setSubcategoryId(int subcategoryId) { this.subcategoryId = subcategoryId; }

    public String getTreeName() { return treeName; }
    public void setTreeName(String treeName) { this.treeName = treeName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public double getAvgRating() { return avgRating; }
    public void setAvgRating(double avgRating) { this.avgRating = avgRating; }

    public int getRatingCount() { return ratingCount; }
    public void setRatingCount(int ratingCount) { this.ratingCount = ratingCount; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public String getCreatorUsername() { return creatorUsername; }
    public void setCreatorUsername(String creatorUsername) { this.creatorUsername = creatorUsername; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public String getSubcategoryName() { return subcategoryName; }
    public void setSubcategoryName(String subcategoryName) { this.subcategoryName = subcategoryName; }
}
