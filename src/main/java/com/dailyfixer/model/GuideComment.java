package com.dailyfixer.model;

import java.sql.Timestamp;

public class GuideComment {
    private int commentId;
    private int guideId;
    private int userId;
    private String comment;
    private Timestamp createdAt;
    
    // For display purposes
    private String userName;

    public GuideComment() {}

    public GuideComment(int guideId, int userId, String comment) {
        this.guideId = guideId;
        this.userId = userId;
        this.comment = comment;
    }

    public int getCommentId() { return commentId; }
    public void setCommentId(int commentId) { this.commentId = commentId; }

    public int getGuideId() { return guideId; }
    public void setGuideId(int guideId) { this.guideId = guideId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
}
