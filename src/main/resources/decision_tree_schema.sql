-- Decision Tree System Schema
-- Apply this after the main schema.sql

-- Table for main categories (Home Repair, Home Electronic Repair, Vehicle Repair)
CREATE TABLE IF NOT EXISTS `decision_categories` (
  `category_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table for subcategories
CREATE TABLE IF NOT EXISTS `decision_subcategories` (
  `subcategory_id` INT NOT NULL AUTO_INCREMENT,
  `category_id` INT NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`subcategory_id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `decision_subcategories_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `decision_categories` (`category_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table for decision trees
CREATE TABLE IF NOT EXISTS `decision_trees` (
  `tree_id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `subcategory_id` INT NOT NULL,
  `tree_name` VARCHAR(200) NOT NULL,
  `description` TEXT,
  `avg_rating` DECIMAL(3,2) DEFAULT 0.00,
  `rating_count` INT DEFAULT 0,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`tree_id`),
  KEY `user_id` (`user_id`),
  KEY `subcategory_id` (`subcategory_id`),
  CONSTRAINT `decision_trees_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `decision_trees_ibfk_2` FOREIGN KEY (`subcategory_id`) REFERENCES `decision_subcategories` (`subcategory_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table for decision nodes (self-referencing tree structure)
CREATE TABLE IF NOT EXISTS `decision_nodes` (
  `node_id` INT NOT NULL AUTO_INCREMENT,
  `tree_id` INT NOT NULL,
  `parent_id` INT DEFAULT NULL,
  `node_text` TEXT NOT NULL,
  `option_label` VARCHAR(255) DEFAULT NULL,
  `node_type` ENUM('QUESTION', 'RESULT') NOT NULL DEFAULT 'QUESTION',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`node_id`),
  KEY `tree_id` (`tree_id`),
  KEY `parent_id` (`parent_id`),
  CONSTRAINT `decision_nodes_ibfk_1` FOREIGN KEY (`tree_id`) REFERENCES `decision_trees` (`tree_id`) ON DELETE CASCADE,
  CONSTRAINT `decision_nodes_ibfk_2` FOREIGN KEY (`parent_id`) REFERENCES `decision_nodes` (`node_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table for user ratings on decision trees
CREATE TABLE IF NOT EXISTS `decision_tree_ratings` (
  `rating_id` INT NOT NULL AUTO_INCREMENT,
  `tree_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `rating` INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`rating_id`),
  UNIQUE KEY `user_tree_unique` (`tree_id`, `user_id`),
  KEY `tree_id` (`tree_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `decision_tree_ratings_ibfk_1` FOREIGN KEY (`tree_id`) REFERENCES `decision_trees` (`tree_id`) ON DELETE CASCADE,
  CONSTRAINT `decision_tree_ratings_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Insert default categories
INSERT INTO `decision_categories` (`name`) VALUES
('Home Repair'),
('Home Electronic Repair'),
('Vehicle Repair');

-- Insert default subcategories for Home Repair
INSERT INTO `decision_subcategories` (`category_id`, `name`)
SELECT c.category_id, s.name
FROM `decision_categories` c
CROSS JOIN (
  SELECT 'Plumbing' AS name UNION ALL
  SELECT 'Electrical (Basic)' UNION ALL
  SELECT 'Carpentry' UNION ALL
  SELECT 'Painting & Finishing' UNION ALL
  SELECT 'Masonry' UNION ALL
  SELECT 'Roofing' UNION ALL
  SELECT 'Flooring' UNION ALL
  SELECT 'Doors & Windows'
) s
WHERE c.name = 'Home Repair';

-- Insert default subcategories for Home Electronic Repair
INSERT INTO `decision_subcategories` (`category_id`, `name`)
SELECT c.category_id, s.name
FROM `decision_categories` c
CROSS JOIN (
  SELECT 'Mobile Devices' AS name UNION ALL
  SELECT 'Computers & Laptops' UNION ALL
  SELECT 'Networking Devices' UNION ALL
  SELECT 'Home Appliances' UNION ALL
  SELECT 'Kitchen Electronics' UNION ALL
  SELECT 'Entertainment Systems' UNION ALL
  SELECT 'Power & Batteries'
) s
WHERE c.name = 'Home Electronic Repair';

-- Insert default subcategories for Vehicle Repair
INSERT INTO `decision_subcategories` (`category_id`, `name`)
SELECT c.category_id, s.name
FROM `decision_categories` c
CROSS JOIN (
  SELECT 'Engine & Mechanical' AS name UNION ALL
  SELECT 'Electrical Systems' UNION ALL
  SELECT 'Braking System' UNION ALL
  SELECT 'Suspension & Steering' UNION ALL
  SELECT 'Transmission' UNION ALL
  SELECT 'Cooling System' UNION ALL
  SELECT 'Tyres & Wheels' UNION ALL
  SELECT 'Body & Paint'
) s
WHERE c.name = 'Vehicle Repair';
