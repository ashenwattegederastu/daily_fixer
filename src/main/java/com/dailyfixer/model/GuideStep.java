package com.dailyfixer.model;

public class GuideStep {
    private int stepId;
    private int guideId;
    private String stepTitle;
    private String stepDescription;
    private byte[] stepImage;

    public GuideStep() {}

    public GuideStep(int guideId, String stepTitle, String stepDescription, byte[] stepImage) {
        this.guideId = guideId;
        this.stepTitle = stepTitle;
        this.stepDescription = stepDescription;
        this.stepImage = stepImage;
    }

    public int getStepId() { return stepId; }
    public void setStepId(int stepId) { this.stepId = stepId; }

    public int getGuideId() { return guideId; }
    public void setGuideId(int guideId) { this.guideId = guideId; }

    public String getStepTitle() { return stepTitle; }
    public void setStepTitle(String stepTitle) { this.stepTitle = stepTitle; }

    public String getStepDescription() { return stepDescription; }
    public void setStepDescription(String stepDescription) { this.stepDescription = stepDescription; }

    public byte[] getStepImage() { return stepImage; }
    public void setStepImage(byte[] stepImage) { this.stepImage = stepImage; }
}
