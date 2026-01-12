package com.dailyfixer.model;

import java.sql.Timestamp;

public class DecisionTreeRating {
    private int ratingId;
    private int treeId;
    private int userId;
    private int rating;
    private Timestamp createdAt;

    public int getRatingId() { return ratingId; }
    public void setRatingId(int ratingId) { this.ratingId = ratingId; }

    public int getTreeId() { return treeId; }
    public void setTreeId(int treeId) { this.treeId = treeId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
