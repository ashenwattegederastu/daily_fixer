-- Add refund tracking fields to orders table
ALTER TABLE orders ADD COLUMN refund_reason VARCHAR(500) NULL;
ALTER TABLE orders ADD COLUMN refund_number VARCHAR(50) NULL;
ALTER TABLE orders ADD COLUMN refunded_at TIMESTAMP NULL;
