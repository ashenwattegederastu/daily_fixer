package com.dailyfixer.model;

public class CartItem {
    private int productId;
    private String name;
    private double price;
    private int quantity;
    private String imageBase64;

    public CartItem(int productId, String name, double price, int quantity, String imageBase64) {
        this.productId = productId;
        this.name = name;
        this.price = price;
        this.quantity = quantity;
        this.imageBase64 = imageBase64;
    }

    public int getProductId() { return productId; }
    public String getName() { return name; }
    public double getPrice() { return price; }
    public int getQuantity() { return quantity; }
    public String getImageBase64() { return imageBase64; }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
}

