package com.dailyfixer.dao;

import java.sql.*;
import java.util.*;

import com.dailyfixer.model.Product;
import com.dailyfixer.model.ProductAttribute;
import com.dailyfixer.model.ProductImage;
import com.dailyfixer.model.ProductVariation;
import com.dailyfixer.model.VariationGroup;
import com.dailyfixer.model.VariationOption;
import com.dailyfixer.util.DBConnection;

public class ProductDAO {

    /**
     * Adds a product with its attributes, images, variation groups/options.
     */
    public int addProduct(Product p) throws Exception {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int productId = -1;

        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false); // Start Transaction

            // 1. Insert Main Product
            String sqlHooks = "INSERT INTO products (store_username, name, brand, description, base_price, category_main, category_sub, category_other, warranty_info, stock_status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            ps = con.prepareStatement(sqlHooks, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, p.getStoreUsername());
            ps.setString(2, p.getName());
            ps.setString(3, p.getBrand());
            ps.setString(4, p.getDescription());
            ps.setDouble(5, p.getBasePrice());
            ps.setString(6, p.getCategoryMain());
            ps.setString(7, p.getCategorySub());
            ps.setString(8, p.getCategoryOther());
            ps.setString(9, p.getWarrantyInfo());
            ps.setString(10, p.getStockStatus());
            ps.executeUpdate();

            rs = ps.getGeneratedKeys();
            if (rs.next()) {
                productId = rs.getInt(1);
                p.setProductId(productId);
            } else {
                throw new SQLException("Creating product failed, no ID obtained.");
            }

            // 2. Insert Images
            insertImages(con, productId, p.getImages());

            // 3. Insert Attributes
            insertAttributes(con, productId, p.getAttributes());

            // 4. Insert Variation Groups & Options
            insertVariationGroups(con, productId, p.getVariationGroups());

            con.commit();
        } catch (Exception e) {
            if (con != null)
                con.rollback();
            throw e;
        } finally {
            if (rs != null)
                rs.close();
            if (ps != null)
                ps.close();
            if (con != null)
                con.close();
        }
        return productId;
    }

    // Helper methods for inserts (used in add and update)
    private void insertImages(Connection con, int productId, List<ProductImage> images) throws SQLException {
        if (images != null && !images.isEmpty()) {
            String imgSql = "INSERT INTO product_images (product_id, image_path, is_main) VALUES (?, ?, ?)";
            try (PreparedStatement psImg = con.prepareStatement(imgSql)) {
                for (ProductImage img : images) {
                    psImg.setInt(1, productId);
                    psImg.setString(2, img.getImagePath());
                    psImg.setBoolean(3, img.isMain());
                    psImg.addBatch();
                }
                psImg.executeBatch();
            }
        }
    }

    private void insertAttributes(Connection con, int productId, List<ProductAttribute> attributes)
            throws SQLException {
        if (attributes != null && !attributes.isEmpty()) {
            String attrSql = "INSERT INTO product_attributes (product_id, attr_name, attr_value) VALUES (?, ?, ?)";
            try (PreparedStatement psAttr = con.prepareStatement(attrSql)) {
                for (ProductAttribute attr : attributes) {
                    psAttr.setInt(1, productId);
                    psAttr.setString(2, attr.getAttrName());
                    psAttr.setString(3, attr.getAttrValue());
                    psAttr.addBatch();
                }
                psAttr.executeBatch();
            }
        }
    }

    private void insertVariationGroups(Connection con, int productId, List<VariationGroup> userGroups)
            throws SQLException {
        if (userGroups != null) {
            String groupSql = "INSERT INTO variation_groups (product_id, group_name) VALUES (?, ?)";
            String optionSql = "INSERT INTO variation_options (group_id, option_value) VALUES (?, ?)";

            // We need to keep track of inserted groups to pass back IDs if needed,
            // but for simple re-insertion, we just process them.
            // If the userGroups came from the frontend with existing IDs, wait,
            // simpler strategy: Assuming 'userGroups' contains the desired state.
            // For Update, we wiped old ones, so we treat these as new inserts.

            PreparedStatement psGroup = con.prepareStatement(groupSql, Statement.RETURN_GENERATED_KEYS);

            for (VariationGroup group : userGroups) {
                psGroup.setInt(1, productId);
                psGroup.setString(2, group.getGroupName());
                psGroup.executeUpdate();

                ResultSet rsGroup = psGroup.getGeneratedKeys();
                int groupId = -1;
                if (rsGroup.next())
                    groupId = rsGroup.getInt(1);
                group.setGroupId(groupId); // Update ID back to object
                rsGroup.close();

                if (group.getOptions() != null) {
                    try (PreparedStatement psOption = con.prepareStatement(optionSql,
                            Statement.RETURN_GENERATED_KEYS)) {
                        for (VariationOption opt : group.getOptions()) {
                            psOption.setInt(1, groupId);
                            psOption.setString(2, opt.getOptionValue());
                            psOption.executeUpdate();

                            ResultSet rsOpt = psOption.getGeneratedKeys();
                            if (rsOpt.next())
                                opt.setOptionId(rsOpt.getInt(1)); // Update ID
                            rsOpt.close();
                        }
                    }
                }
            }
            if (psGroup != null)
                psGroup.close();
        }
    }

    /**
     * Adds a specific product variation (SKU) and maps it to the selected options.
     */
    public void addProductVariation(int productId, ProductVariation pv, List<Integer> optionIds) throws Exception {
        String sql = "INSERT INTO product_variations (product_id, sku, price, stock_quantity, is_active) VALUES (?, ?, ?, ?, ?)";
        String mapSql = "INSERT INTO product_variation_options_mapping (variation_id, option_id) VALUES (?, ?)";

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false); // Transactional

            ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, productId);
            ps.setString(2, pv.getSku());
            ps.setDouble(3, pv.getPrice());
            ps.setInt(4, pv.getStockQuantity());
            ps.setBoolean(5, pv.isActive());
            ps.executeUpdate();

            rs = ps.getGeneratedKeys();
            int varId = -1;
            if (rs.next())
                varId = rs.getInt(1);

            try (PreparedStatement psMap = con.prepareStatement(mapSql)) {
                for (Integer optId : optionIds) {
                    psMap.setInt(1, varId);
                    psMap.setInt(2, optId);
                    psMap.addBatch();
                }
                psMap.executeBatch();
            }

            con.commit();
        } catch (Exception e) {
            if (con != null)
                con.rollback();
            throw e;
        } finally {
            if (rs != null)
                rs.close();
            if (ps != null)
                ps.close();
            if (con != null)
                con.close();
        }
    }

    public void updateProduct(Product p) throws Exception {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            // 1. Update Main Product Fields
            String sql = "UPDATE products SET name=?, brand=?, description=?, base_price=?, category_main=?, category_sub=?, category_other=?, warranty_info=?, stock_status=? WHERE product_id=?";
            ps = con.prepareStatement(sql);
            ps.setString(1, p.getName());
            ps.setString(2, p.getBrand());
            ps.setString(3, p.getDescription());
            ps.setDouble(4, p.getBasePrice());
            ps.setString(5, p.getCategoryMain());
            ps.setString(6, p.getCategorySub());
            ps.setString(7, p.getCategoryOther());
            ps.setString(8, p.getWarrantyInfo());
            ps.setString(9, p.getStockStatus());
            ps.setInt(10, p.getProductId());
            ps.executeUpdate();
            ps.close();

            // 2. Handle Images
            // If new images provided, wipe old and insert new. (Simplification)
            // Or usually we append. But for now, let's assume we handle images separately
            // or just append if list provided?
            // In EditProductServlet, we'll likely handle image replacement only if a file
            // is uploaded.
            // If p.getImages() is populated, assume replacement of MAIN image logic or full
            // replacement.
            // Let's implement full replacement if list provided.
            if (p.getImages() != null && !p.getImages().isEmpty()) {
                // DELETE old images? Or just update? Let's delete for simplicity of "update
                // state".
                try (PreparedStatement delImg = con.prepareStatement("DELETE FROM product_images WHERE product_id=?")) {
                    delImg.setInt(1, p.getProductId());
                    delImg.executeUpdate();
                }
                insertImages(con, p.getProductId(), p.getImages());
            }

            // 3. Handle Attributes (Full Replace)
            try (PreparedStatement delAttr = con
                    .prepareStatement("DELETE FROM product_attributes WHERE product_id=?")) {
                delAttr.setInt(1, p.getProductId());
                delAttr.executeUpdate();
            }
            insertAttributes(con, p.getProductId(), p.getAttributes());

            // 4. Handle Variations (Full Replace)
            // First delete existing variations (cascade will handle mappings)
            // Wait, mappings are linked to OPTIONS.
            // If we delete Groups/Options, mappings die (cascade).
            // But variations themselves?
            // "product_variations" is child of "product".
            // "product_variation_options_mapping" is child of "product_variations" AND
            // "variation_options".
            // So if we delete Groups (-> Options delete -> Mappings delete), then we must
            // ALSO delete Variations manually?
            // Or do we delete Variations first?

            // Safe order: Delete Variations (deletes Mappings via cascade if set up, or
            // just delete variations)
            // Then Delete Groups (deletes Options)

            try (PreparedStatement delVars = con
                    .prepareStatement("DELETE FROM product_variations WHERE product_id=?")) {
                delVars.setInt(1, p.getProductId());
                delVars.executeUpdate();
            }
            // Mappings should be gone if they cascade from variations.
            // But just in case, deleting Groups deletes Options which deletes Mappings (via
            // FK option_id).

            try (PreparedStatement delGroups = con
                    .prepareStatement("DELETE FROM variation_groups WHERE product_id=?")) {
                delGroups.setInt(1, p.getProductId());
                delGroups.executeUpdate();
            }

            // Re-insert Groups & Options
            insertVariationGroups(con, p.getProductId(), p.getVariationGroups());

            // Note: Re-inserting specific Product Variations (SKUs) is done via separate
            // calls usually
            // (addProductVariation loop in Servlet), OR we can do it here if passed in
            // Product object.
            // Product object doesn't have a list of ProductVariation objects directly
            // mapped in the class structure above easily?
            // Actually it doesn't hold `List<ProductVariation> variations`.
            // So the Servlet loop calling `addProductVariation` is still needed for the SKU
            // entries.
            // The Servlet for Edit will need to handle this:
            // 1. Call this updateProduct() -> Clears everything and sets up Grid structure.
            // 2. Loop SKUs -> Call addProductVariation().

            con.commit();
        } catch (Exception e) {
            if (con != null)
                con.rollback();
            throw e;
        } finally {
            if (ps != null)
                ps.close();
            if (con != null)
                con.close();
        }
    }

    public List<Product> getAllProducts(String storeUsername) throws Exception {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.*, pi.image_path FROM products p LEFT JOIN product_images pi ON p.product_id = pi.product_id AND pi.is_main = 1 WHERE p.store_username=?";

        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, storeUsername);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product();
                p.setProductId(rs.getInt("product_id"));
                p.setName(rs.getString("name"));
                p.setBrand(rs.getString("brand"));
                p.setCategoryMain(rs.getString("category_main"));
                p.setCategorySub(rs.getString("category_sub"));
                p.setBasePrice(rs.getDouble("base_price"));
                p.setStockStatus(rs.getString("stock_status"));
                p.setStoreUsername(rs.getString("store_username"));

                String path = rs.getString("image_path");
                if (path != null) {
                    ProductImage img = new ProductImage();
                    img.setImagePath(path);
                    img.setMain(true);
                    List<ProductImage> imgs = new ArrayList<>();
                    imgs.add(img);
                    p.setImages(imgs);
                }

                list.add(p);
            }
        }
        return list;
    }

    public void deleteProduct(int id) throws Exception {
        String sql = "DELETE FROM products WHERE product_id=?";
        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public Product getProductById(int id) throws Exception {
        Product p = null;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();

            // 1. Fetch Main Product
            String sql = "SELECT * FROM products WHERE product_id=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();

            if (rs.next()) {
                p = new Product();
                p.setProductId(rs.getInt("product_id"));
                p.setName(rs.getString("name"));
                p.setBrand(rs.getString("brand"));
                p.setCategoryMain(rs.getString("category_main"));
                p.setCategorySub(rs.getString("category_sub"));
                p.setCategoryOther(rs.getString("category_other"));
                p.setBasePrice(rs.getDouble("base_price"));
                p.setStockStatus(rs.getString("stock_status"));
                p.setDescription(rs.getString("description"));
                p.setWarrantyInfo(rs.getString("warranty_info"));
                p.setStoreUsername(rs.getString("store_username"));
            }
            rs.close();
            ps.close();

            if (p != null) {
                // 2. Fetch Images
                List<ProductImage> images = new ArrayList<>();
                ps = con.prepareStatement("SELECT * FROM product_images WHERE product_id=?");
                ps.setInt(1, id);
                rs = ps.executeQuery();
                while (rs.next()) {
                    ProductImage img = new ProductImage();
                    img.setImageId(rs.getInt("image_id"));
                    img.setProductId(id);
                    img.setImagePath(rs.getString("image_path"));
                    img.setMain(rs.getBoolean("is_main"));
                    images.add(img);
                }
                p.setImages(images);
                rs.close();
                ps.close();

                // 3. Fetch Attributes
                List<ProductAttribute> attrs = new ArrayList<>();
                ps = con.prepareStatement("SELECT * FROM product_attributes WHERE product_id=?");
                ps.setInt(1, id);
                rs = ps.executeQuery();
                while (rs.next()) {
                    ProductAttribute pa = new ProductAttribute();
                    pa.setAttributeId(rs.getInt("attribute_id"));
                    pa.setProductId(id);
                    pa.setAttrName(rs.getString("attr_name"));
                    pa.setAttrValue(rs.getString("attr_value"));
                    attrs.add(pa);
                }
                p.setAttributes(attrs);
                rs.close();
                ps.close();

                // 4. Fetch Variation Groups & Options
                List<VariationGroup> groups = new ArrayList<>();
                ps = con.prepareStatement("SELECT * FROM variation_groups WHERE product_id=?");
                ps.setInt(1, id);
                rs = ps.executeQuery();
                while (rs.next()) {
                    VariationGroup vg = new VariationGroup();
                    vg.setGroupId(rs.getInt("group_id"));
                    vg.setProductId(id);
                    vg.setGroupName(rs.getString("group_name"));

                    // Fetch Options for this group
                    List<VariationOption> opts = new ArrayList<>();
                    try (PreparedStatement psOpt = con
                            .prepareStatement("SELECT * FROM variation_options WHERE group_id=?")) {
                        psOpt.setInt(1, vg.getGroupId());
                        try (ResultSet rsOpt = psOpt.executeQuery()) {
                            while (rsOpt.next()) {
                                VariationOption vo = new VariationOption();
                                vo.setOptionId(rsOpt.getInt("option_id"));
                                vo.setGroupId(vg.getGroupId());
                                vo.setOptionValue(rsOpt.getString("option_value"));
                                opts.add(vo);
                            }
                        }
                    }
                    vg.setOptions(opts);
                    groups.add(vg);
                }
                p.setVariationGroups(groups);

                // Note: We are not fetching ProductVariations (the SKUs) here and attaching to
                // Product
                // because Product model doesn't hold `List<ProductVariation>`.
                // However, for the Edit UI, we might need to know the existing
                // SKUs/Stock/Price.
                // It would be useful to return them separately or add a field to Product.
                // But typically the UI recreates the table. If we want to PRE-FILL the table,
                // we need this data.
                // Let's assume we can fetch it in the Servlet separately and put in request
                // attribute,
                // OR add a transient field to Product.
            }

        } finally {
            if (rs != null)
                rs.close();
            if (ps != null)
                ps.close();
            if (con != null)
                con.close();
        }
        return p;
    }

    // Additional method to fetch SKUs for editing
    public List<ProductVariation> getProductVariations(int productId) throws Exception {
        List<ProductVariation> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement("SELECT * FROM product_variations WHERE product_id=?")) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductVariation pv = new ProductVariation();
                pv.setVariationId(rs.getInt("variation_id"));
                pv.setProductId(productId);
                pv.setSku(rs.getString("sku"));
                pv.setPrice(rs.getDouble("price"));
                pv.setStockQuantity(rs.getInt("stock_quantity"));
                // Need to fetch mapped options? Yes, to match rows.
                // But for now, returning basic list.
                list.add(pv);
            }
        }
        return list;
    }
}
