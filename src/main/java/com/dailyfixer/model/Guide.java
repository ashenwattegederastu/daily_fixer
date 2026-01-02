package com.dailyfixer.model;

import java.sql.Timestamp;
import java.util.List;

public class Guide {
    private int guideId;
    private String title;
    private byte[] mainImage;
    private String mainCategory;
    private String subCategory;
    private String youtubeUrl;
    private int createdBy;
    private String createdRole;
    private Timestamp createdAt;
    private List<String> requirements;
    private List<GuideStep> steps;
    
    // For display purposes
    private String creatorName;
    private int upVotes;
    private int downVotes;

    // Constructor
    public Guide() { }

    public Guide(String title, byte[] mainImage, String mainCategory, String subCategory, 
                 String youtubeUrl, int createdBy, String createdRole) {
        this.title = title;
        this.mainImage = mainImage;
        this.mainCategory = mainCategory;
        this.subCategory = subCategory;
        this.youtubeUrl = youtubeUrl;
        this.createdBy = createdBy;
        this.createdRole = createdRole;
    }

    // Getters and Setters
    public int getGuideId() { return guideId; }
    public void setGuideId(int guideId) { this.guideId = guideId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public byte[] getMainImage() { return mainImage; }
    public void setMainImage(byte[] mainImage) { this.mainImage = mainImage; }

    public String getMainCategory() { return mainCategory; }
    public void setMainCategory(String mainCategory) { this.mainCategory = mainCategory; }

    public String getSubCategory() { return subCategory; }
    public void setSubCategory(String subCategory) { this.subCategory = subCategory; }

    public String getYoutubeUrl() { return youtubeUrl; }
    public void setYoutubeUrl(String youtubeUrl) { this.youtubeUrl = youtubeUrl; }

    public int getCreatedBy() { return createdBy; }
    public void setCreatedBy(int createdBy) { this.createdBy = createdBy; }

    public String getCreatedRole() { return createdRole; }
    public void setCreatedRole(String createdRole) { this.createdRole = createdRole; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public List<String> getRequirements() { return requirements; }
    public void setRequirements(List<String> requirements) { this.requirements = requirements; }

    public List<GuideStep> getSteps() { return steps; }
    public void setSteps(List<GuideStep> steps) { this.steps = steps; }

    public String getCreatorName() { return creatorName; }
    public void setCreatorName(String creatorName) { this.creatorName = creatorName; }

    public int getUpVotes() { return upVotes; }
    public void setUpVotes(int upVotes) { this.upVotes = upVotes; }

    public int getDownVotes() { return downVotes; }
    public void setDownVotes(int downVotes) { this.downVotes = downVotes; }
}
