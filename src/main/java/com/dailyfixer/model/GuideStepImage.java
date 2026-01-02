package com.dailyfixer.model;

public class GuideStepImage {
    private int imageId;
    private int stepId;
    private byte[] imageData;

    public GuideStepImage() {}

    public GuideStepImage(int stepId, byte[] imageData) {
        this.stepId = stepId;
        this.imageData = imageData;
    }

    public int getImageId() { return imageId; }
    public void setImageId(int imageId) { this.imageId = imageId; }

    public int getStepId() { return stepId; }
    public void setStepId(int stepId) { this.stepId = stepId; }

    public byte[] getImageData() { return imageData; }
    public void setImageData(byte[] imageData) { this.imageData = imageData; }
}
