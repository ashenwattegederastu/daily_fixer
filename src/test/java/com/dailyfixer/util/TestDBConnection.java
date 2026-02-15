package com.dailyfixer.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * Test-specific database connection utility that uses H2 in-memory database.
 * This mimics the production DBConnection but points to H2 instead of MySQL.
 */
public class TestDBConnection {

    private static final String URL = "jdbc:h2:mem:dailyfixer_test;DB_CLOSE_DELAY=-1;MODE=MySQL";
    private static final String USER = "sa";
    private static final String PASS = "";

    private static boolean schemaInitialized = false;

    /**
     * Get a connection to the H2 test database.
     * Initializes the schema on first call.
     */
    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName("org.h2.Driver");
        Connection conn = DriverManager.getConnection(URL, USER, PASS);
        
        // Initialize schema on first connection
        if (!schemaInitialized) {
            initializeSchema(conn);
            schemaInitialized = true;
        }
        
        return conn;
    }

    /**
     * Initialize the test database schema.
     * Creates tables needed for tests.
     */
    private static void initializeSchema(Connection conn) throws SQLException {
        try (Statement stmt = conn.createStatement()) {
            // Users table
            stmt.execute("CREATE TABLE IF NOT EXISTS users (" +
                    "user_id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "first_name VARCHAR(100), " +
                    "last_name VARCHAR(100), " +
                    "username VARCHAR(50) UNIQUE NOT NULL, " +
                    "email VARCHAR(100) UNIQUE NOT NULL, " +
                    "password VARCHAR(255) NOT NULL, " +
                    "phone_number VARCHAR(20), " +
                    "city VARCHAR(100), " +
                    "role VARCHAR(20) DEFAULT 'user', " +
                    "status VARCHAR(20) DEFAULT 'active'" +
                    ")");

            // Services table
            stmt.execute("CREATE TABLE IF NOT EXISTS services (" +
                    "service_id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "technician_id INT NOT NULL, " +
                    "service_name VARCHAR(200) NOT NULL, " +
                    "description TEXT, " +
                    "category VARCHAR(100), " +
                    "pricing_type VARCHAR(50), " +
                    "fixed_rate DECIMAL(10,2), " +
                    "hourly_rate DECIMAL(10,2), " +
                    "inspection_charge DECIMAL(10,2), " +
                    "transport_charge DECIMAL(10,2), " +
                    "available_dates TEXT, " +
                    "service_image BLOB, " +
                    "image_type VARCHAR(50)" +
                    ")");

            // Stores table
            stmt.execute("CREATE TABLE IF NOT EXISTS stores (" +
                    "store_id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "user_id INT NOT NULL, " +
                    "store_name VARCHAR(200) NOT NULL, " +
                    "store_address TEXT, " +
                    "store_city VARCHAR(100), " +
                    "store_type VARCHAR(50), " +
                    "latitude DOUBLE, " +
                    "longitude DOUBLE" +
                    ")");

            // Products table
            stmt.execute("CREATE TABLE IF NOT EXISTS products (" +
                    "product_id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "store_id INT NOT NULL, " +
                    "name VARCHAR(200) NOT NULL, " +
                    "type VARCHAR(100), " +
                    "quantity INT, " +
                    "quantity_unit VARCHAR(20), " +
                    "price DECIMAL(10,2), " +
                    "image BLOB, " +
                    "description TEXT" +
                    ")");
        }
    }

    /**
     * Clear all data from tables for test isolation.
     */
    public static void clearAllTables() throws SQLException, ClassNotFoundException {
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.execute("SET REFERENTIAL_INTEGRITY FALSE");
            stmt.execute("TRUNCATE TABLE users");
            stmt.execute("TRUNCATE TABLE services");
            stmt.execute("TRUNCATE TABLE stores");
            stmt.execute("TRUNCATE TABLE products");
            stmt.execute("SET REFERENTIAL_INTEGRITY TRUE");
        }
    }

    /**
     * Reset the schema initialization flag for testing purposes.
     */
    public static void resetSchemaFlag() {
        schemaInitialized = false;
    }
}
