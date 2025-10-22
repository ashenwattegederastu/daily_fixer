package com.dailyfixer.model;

import java.util.List;

public class Guide {
    private int guideId;
    private int volunteerId;
    private String title;
    private byte[] mainImage;
    private List<String> requirements;  // new
    private List<GuideStep> steps;      // new

    // Constructor
    public Guide() { }

    public Guide(int volunteerId, String title, byte[] mainImage) {
        this.volunteerId = volunteerId;
        this.title = title;
        this.mainImage = mainImage;
    }

    // Getters and Setters
    public int getGuideId() { return guideId; }
    public void setGuideId(int guideId) { this.guideId = guideId; }

    public int getVolunteerId() { return volunteerId; }
    public void setVolunteerId(int volunteerId) { this.volunteerId = volunteerId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public byte[] getMainImage() { return mainImage; }
    public void setMainImage(byte[] mainImage) { this.mainImage = mainImage; }

    public List<String> getRequirements() { return requirements; }
    public void setRequirements(List<String> requirements) { this.requirements = requirements; }

    public List<GuideStep> getSteps() { return steps; }
    public void setSteps(List<GuideStep> steps) { this.steps = steps; }
}
