package com.dailyfixer.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/dailyfixer?useSSL=false&serverTimezone=UTC";
//    private String jdbcURL = "jdbc:mysql://localhost:3306/dailyfixer?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root"; // change if needed
    private static final String PASS = "admin";

    public static Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(URL, USER, PASS);
    }
}

