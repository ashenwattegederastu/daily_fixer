package com.dailyfixer.model;

import java.sql.Timestamp;
import java.util.List;

public class Product {
    private int productId;
    private String storeUsername;
    private String name;
    private String brand;
    private String description;
    private double basePrice;
    private String categoryMain;
    private String categorySub;
    private String categoryOther;
    private String warrantyInfo;
    private String stockStatus; // ACTIVE, OUT_OF_STOCK, DISCONTINUED
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Lists for related data (populated when needed)
    private List<ProductAttribute> attributes;
    private List<VariationGroup> variationGroups;
    private List<ProductImage> images;

    // Getters and Setters
    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getStoreUsername() {
        return storeUsername;
    }

    public void setStoreUsername(String storeUsername) {
        this.storeUsername = storeUsername;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getBasePrice() {
        return basePrice;
    }

    public void setBasePrice(double basePrice) {
        this.basePrice = basePrice;
    }

    public String getCategoryMain() {
        return categoryMain;
    }

    public void setCategoryMain(String categoryMain) {
        this.categoryMain = categoryMain;
    }

    public String getCategorySub() {
        return categorySub;
    }

    public void setCategorySub(String categorySub) {
        this.categorySub = categorySub;
    }

    public String getCategoryOther() {
        return categoryOther;
    }

    public void setCategoryOther(String categoryOther) {
        this.categoryOther = categoryOther;
    }

    public String getWarrantyInfo() {
        return warrantyInfo;
    }

    public void setWarrantyInfo(String warrantyInfo) {
        this.warrantyInfo = warrantyInfo;
    }

    public String getStockStatus() {
        return stockStatus;
    }

    public void setStockStatus(String stockStatus) {
        this.stockStatus = stockStatus;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public List<ProductAttribute> getAttributes() {
        return attributes;
    }

    public void setAttributes(List<ProductAttribute> attributes) {
        this.attributes = attributes;
    }

    public List<VariationGroup> getVariationGroups() {
        return variationGroups;
    }

    public void setVariationGroups(List<VariationGroup> variationGroups) {
        this.variationGroups = variationGroups;
    }

    public List<ProductImage> getImages() {
        return images;
    }

    public void setImages(List<ProductImage> images) {
        this.images = images;
    }
}
