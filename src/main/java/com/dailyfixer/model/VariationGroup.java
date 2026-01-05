package com.dailyfixer.model;

import java.util.List;

public class VariationGroup {
    private int groupId;
    private int productId;
    private String groupName;

    // List of options within this group (e.g., Red, Blue)
    private List<VariationOption> options;

    public int getGroupId() {
        return groupId;
    }

    public void setGroupId(int groupId) {
        this.groupId = groupId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getGroupName() {
        return groupName;
    }

    public void setGroupName(String groupName) {
        this.groupName = groupName;
    }

    public List<VariationOption> getOptions() {
        return options;
    }

    public void setOptions(List<VariationOption> options) {
        this.options = options;
    }
}
