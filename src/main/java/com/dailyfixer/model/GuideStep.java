package com.dailyfixer.model;

import java.util.List;

public class GuideStep {
    private int stepId;
    private int guideId;
    private int stepOrder;
    private String stepTitle;
    private String stepBody;
    private List<byte[]> images;

    public GuideStep() {}

    public GuideStep(int guideId, int stepOrder, String stepTitle, String stepBody) {
        this.guideId = guideId;
        this.stepOrder = stepOrder;
        this.stepTitle = stepTitle;
        this.stepBody = stepBody;
    }

    public int getStepId() { return stepId; }
    public void setStepId(int stepId) { this.stepId = stepId; }

    public int getGuideId() { return guideId; }
    public void setGuideId(int guideId) { this.guideId = guideId; }

    public int getStepOrder() { return stepOrder; }
    public void setStepOrder(int stepOrder) { this.stepOrder = stepOrder; }

    public String getStepTitle() { return stepTitle; }
    public void setStepTitle(String stepTitle) { this.stepTitle = stepTitle; }

    public String getStepBody() { return stepBody; }
    public void setStepBody(String stepBody) { this.stepBody = stepBody; }

    public List<byte[]> getImages() { return images; }
    public void setImages(List<byte[]> images) { this.images = images; }
}
