package com.dailyfixer.dao;

import com.dailyfixer.model.Store;
import com.dailyfixer.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

public class StoreDAO {

    /**
     * Insert store record that references an existing users.user_id.
     * Returns true if insert succeeded and sets the generated storeId on the Store object.
     */
    public boolean addStore(Store store) {
        String sql = "INSERT INTO stores (user_id, store_name, store_address, store_city, store_type) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, store.getUserId());
            ps.setString(2, store.getStoreName());
            ps.setString(3, store.getStoreAddress());
            ps.setString(4, store.getStoreCity());
            ps.setString(5, store.getStoreType());

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        store.setStoreId(rs.getInt(1));
                    }
                }
                return true;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
