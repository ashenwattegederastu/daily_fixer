package com.dailyfixer.model;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class DecisionNode {
    private int nodeId;
    private int treeId;
    private Integer parentId; // null for root node
    private String nodeText;
    private String optionLabel;
    private String nodeType; // 'QUESTION' or 'RESULT'
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // For hierarchical representation
    private List<DecisionNode> children = new ArrayList<>();

    public int getNodeId() { return nodeId; }
    public void setNodeId(int nodeId) { this.nodeId = nodeId; }

    public int getTreeId() { return treeId; }
    public void setTreeId(int treeId) { this.treeId = treeId; }

    public Integer getParentId() { return parentId; }
    public void setParentId(Integer parentId) { this.parentId = parentId; }

    public String getNodeText() { return nodeText; }
    public void setNodeText(String nodeText) { this.nodeText = nodeText; }

    public String getOptionLabel() { return optionLabel; }
    public void setOptionLabel(String optionLabel) { this.optionLabel = optionLabel; }

    public String getNodeType() { return nodeType; }
    public void setNodeType(String nodeType) { this.nodeType = nodeType; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public List<DecisionNode> getChildren() { return children; }
    public void setChildren(List<DecisionNode> children) { this.children = children; }
    public void addChild(DecisionNode child) { this.children.add(child); }
}
