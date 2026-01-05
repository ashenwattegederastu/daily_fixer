-- =====================================================
-- DailyFixer Store Product System - Normalized Schema
-- Covers: Products, Dynamic Attributes, Variations, Images
-- =====================================================

SET FOREIGN_KEY_CHECKS = 0;

-- 1. Clean up old tables (CAUTION: Data Loss)
DROP TABLE IF EXISTS product_variation_options_mapping;
DROP TABLE IF EXISTS product_variations;
DROP TABLE IF EXISTS variation_options;
DROP TABLE IF EXISTS variation_groups;
DROP TABLE IF EXISTS product_attributes;
DROP TABLE IF EXISTS product_images;
DROP TABLE IF EXISTS products;

SET FOREIGN_KEY_CHECKS = 1;

-- 2. Main Products Table
-- Defines the core "Parent" product.
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    store_username VARCHAR(50) NOT NULL, -- Links to the store owner
    name VARCHAR(255) NOT NULL,
    brand VARCHAR(100),
    description TEXT,
    base_price DECIMAL(10, 2) NOT NULL, -- A base price for display/default
    category_main VARCHAR(100) NOT NULL,
    category_sub VARCHAR(100) NOT NULL,
    category_other VARCHAR(100), -- If "Other" is selected
    warranty_info VARCHAR(255),
    stock_status ENUM('ACTIVE', 'OUT_OF_STOCK', 'DISCONTINUED') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_store (store_username),
    INDEX idx_category (category_main, category_sub)
);

-- 3. Product Images
-- Stores paths instead of BLOBs for efficiency.
CREATE TABLE product_images (
    image_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    image_path VARCHAR(255) NOT NULL,
    is_main BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- 4. Dynamic Attributes
-- Stores category-specific fields (e.g., "Voltage": "220V", "Material": "Wood")
CREATE TABLE product_attributes (
    attribute_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    attr_name VARCHAR(100) NOT NULL,
    attr_value VARCHAR(255) NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- 5. Variation Groups
-- Defines the axes of variation (e.g., "Color", "Size") for a product.
CREATE TABLE variation_groups (
    group_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    group_name VARCHAR(100) NOT NULL, -- e.g., "Color", "Size"
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- 6. Variation Options
-- Defines the specific values for a group (e.g., "Red", "Blue" for group "Color").
CREATE TABLE variation_options (
    option_id INT AUTO_INCREMENT PRIMARY KEY,
    group_id INT NOT NULL,
    option_value VARCHAR(100) NOT NULL, -- e.g., "Red", "Small"
    FOREIGN KEY (group_id) REFERENCES variation_groups(group_id) ON DELETE CASCADE
);

-- 7. Product Variations (The SKUs)
-- Represents a specific sellable unit (e.g., Red Small Shirt).
CREATE TABLE product_variations (
    variation_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    sku VARCHAR(100), -- Optional Stock Keeping Unit code
    price DECIMAL(10, 2) NOT NULL, -- Specific price for this variation
    stock_quantity INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- 8. Variation Option Mapping
-- Links a SKU (product_variations) to its specific options.
-- e.g., Variation #101 maps to Option "Red" and Option "Small".
CREATE TABLE product_variation_options_mapping (
    mapping_id INT AUTO_INCREMENT PRIMARY KEY,
    variation_id INT NOT NULL,
    option_id INT NOT NULL,
    FOREIGN KEY (variation_id) REFERENCES product_variations(variation_id) ON DELETE CASCADE,
    FOREIGN KEY (option_id) REFERENCES variation_options(option_id) ON DELETE CASCADE
);

-- usage:
-- 1. Insert into products
-- 2. Insert into variation_groups (Color, Size)
-- 3. Insert into variation_options (Red, Blue, Small, Large)
-- 4. Insert into product_variations (Create a row for Red-Small)
-- 5. Insert into mapping (Link Red-Small ID to Red ID, Link Red-Small ID to Small ID)
