package com.dailyfixer.dao;

import com.dailyfixer.model.User;
import com.dailyfixer.model.UserDriver;
import java.sql.*;

public class UserDAO {

    private String jdbcURL = "jdbc:mysql://localhost:3306/dailyfixer";
    private String jdbcUsername = "root";
    private String jdbcPassword = "admin";

    private Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // load driver
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        return DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
    }

    // 🔹 Validate login
    public User validateUser(String username, String password) {
        User user = null;
        String sql = "SELECT * FROM users WHERE username=? AND password=?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setFname(rs.getString("fname"));
                user.setLname(rs.getString("lname"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setUsertype(rs.getString("usertype"));
                user.setProfilepic(rs.getString("profilepic"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    // 🔹 Register general user (hardcode usertype = 'user')
    public boolean registerUser(User user) {
        boolean success = false;
        String sql = "INSERT INTO users (username, password, fname, lname, phone, email, usertype, profilepic) " +
                "VALUES (?, ?, ?, ?, ?, ?, 'user', ?)";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPassword());  // plain text for now
            stmt.setString(3, user.getFname());
            stmt.setString(4, user.getLname());
            stmt.setString(5, user.getPhone());
            stmt.setString(6, user.getEmail());
            stmt.setString(7, user.getProfilepic());

            int rows = stmt.executeUpdate();
            success = rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    // 🔹 Register driver (kept as is)
    public boolean registerDriver(User user, UserDriver driver) {
        boolean success = false;
        String sqlUser = "INSERT INTO users (username, password, fname, lname, phone, email, usertype, profilepic) VALUES (?, ?, ?, ?, ?, ?, 'driver', ?)";
        String sqlDriver = "INSERT INTO user_driver (user_id, real_pic, service_area, license_pic) VALUES (?, ?, ?, ?)";

        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);

            // Insert into users
            PreparedStatement stmtUser = conn.prepareStatement(sqlUser, Statement.RETURN_GENERATED_KEYS);
            stmtUser.setString(1, user.getUsername());
            stmtUser.setString(2, user.getPassword());
            stmtUser.setString(3, user.getFname());
            stmtUser.setString(4, user.getLname());
            stmtUser.setString(5, user.getPhone());
            stmtUser.setString(6, user.getEmail());
            stmtUser.setString(7, user.getProfilepic());
            stmtUser.executeUpdate();

            ResultSet rs = stmtUser.getGeneratedKeys();
            if (rs.next()) {
                int userId = rs.getInt(1);
                driver.setUser(user);
                driver.getUser().setId(userId);

                // Insert into driver table
                PreparedStatement stmtDriver = conn.prepareStatement(sqlDriver);
                stmtDriver.setInt(1, userId);
                stmtDriver.setString(2, driver.getRealPic());
                stmtDriver.setString(3, driver.getServiceArea());
                stmtDriver.setString(4, driver.getLicensePic());
                stmtDriver.executeUpdate();
            }

            conn.commit();
            success = true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }
}
