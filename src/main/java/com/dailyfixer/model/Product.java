package com.dailyfixer.model;


public class Product {
    private int productId;
    private String name;
    private String type;
    private double quantity;
    private String quantityUnit;
    private double price;
    private byte[] image;
    private String storeUsername;

    // Getters and Setters
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public double getQuantity() { return quantity; }
    public void setQuantity(double quantity) { this.quantity = quantity; }
    public String getQuantityUnit() { return quantityUnit; }
    public void setQuantityUnit(String quantityUnit) { this.quantityUnit = quantityUnit; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    public byte[] getImage() { return image; }
    public void setImage(byte[] image) { this.image = image; }
    public String getStoreUsername() { return storeUsername; }
    public void setStoreUsername(String storeUsername) { this.storeUsername = storeUsername; }
}
