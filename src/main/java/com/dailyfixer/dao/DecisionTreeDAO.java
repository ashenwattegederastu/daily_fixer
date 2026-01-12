package com.dailyfixer.dao;

import com.dailyfixer.model.DecisionNode;
import com.dailyfixer.model.DecisionTree;
import com.dailyfixer.model.DecisionTreeRating;
import com.dailyfixer.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DecisionTreeDAO {

    // =============== TREE CRUD ===============

    public List<DecisionTree> getAllTrees() {
        List<DecisionTree> trees = new ArrayList<>();
        String sql = "SELECT dt.*, u.username, c.name as category_name, s.name as subcategory_name " +
                     "FROM decision_trees dt " +
                     "JOIN users u ON dt.user_id = u.user_id " +
                     "JOIN decision_subcategories s ON dt.subcategory_id = s.subcategory_id " +
                     "JOIN decision_categories c ON s.category_id = c.category_id " +
                     "ORDER BY dt.created_at DESC";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                trees.add(mapTree(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return trees;
    }

    public List<DecisionTree> getTreesByUserId(int userId) {
        List<DecisionTree> trees = new ArrayList<>();
        String sql = "SELECT dt.*, u.username, c.name as category_name, s.name as subcategory_name " +
                     "FROM decision_trees dt " +
                     "JOIN users u ON dt.user_id = u.user_id " +
                     "JOIN decision_subcategories s ON dt.subcategory_id = s.subcategory_id " +
                     "JOIN decision_categories c ON s.category_id = c.category_id " +
                     "WHERE dt.user_id = ? " +
                     "ORDER BY dt.created_at DESC";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    trees.add(mapTree(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return trees;
    }

    public List<DecisionTree> getTreesBySubcategoryId(int subcategoryId) {
        List<DecisionTree> trees = new ArrayList<>();
        String sql = "SELECT dt.*, u.username, c.name as category_name, s.name as subcategory_name " +
                     "FROM decision_trees dt " +
                     "JOIN users u ON dt.user_id = u.user_id " +
                     "JOIN decision_subcategories s ON dt.subcategory_id = s.subcategory_id " +
                     "JOIN decision_categories c ON s.category_id = c.category_id " +
                     "WHERE dt.subcategory_id = ? " +
                     "ORDER BY dt.avg_rating DESC, dt.created_at DESC";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, subcategoryId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    trees.add(mapTree(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return trees;
    }

    public DecisionTree getTreeById(int treeId) {
        String sql = "SELECT dt.*, u.username, c.name as category_name, s.name as subcategory_name " +
                     "FROM decision_trees dt " +
                     "JOIN users u ON dt.user_id = u.user_id " +
                     "JOIN decision_subcategories s ON dt.subcategory_id = s.subcategory_id " +
                     "JOIN decision_categories c ON s.category_id = c.category_id " +
                     "WHERE dt.tree_id = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, treeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapTree(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public int createTree(int userId, int subcategoryId, String treeName, String description) {
        String sql = "INSERT INTO decision_trees (user_id, subcategory_id, tree_name, description) VALUES (?, ?, ?, ?)";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, userId);
            ps.setInt(2, subcategoryId);
            ps.setString(3, treeName);
            ps.setString(4, description);
            
            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean updateTree(int treeId, String treeName, String description) {
        String sql = "UPDATE decision_trees SET tree_name = ?, description = ? WHERE tree_id = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, treeName);
            ps.setString(2, description);
            ps.setInt(3, treeId);
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteTree(int treeId) {
        String sql = "DELETE FROM decision_trees WHERE tree_id = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, treeId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // =============== NODE CRUD ===============

    public List<DecisionNode> getNodesByTreeId(int treeId) {
        List<DecisionNode> nodes = new ArrayList<>();
        String sql = "SELECT * FROM decision_nodes WHERE tree_id = ? ORDER BY node_id";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, treeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    nodes.add(mapNode(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return nodes;
    }

    public DecisionNode getHierarchicalTree(int treeId) {
        List<DecisionNode> allNodes = getNodesByTreeId(treeId);
        if (allNodes.isEmpty()) {
            return null;
        }
        
        Map<Integer, DecisionNode> nodeMap = new HashMap<>();
        DecisionNode root = null;
        
        for (DecisionNode node : allNodes) {
            nodeMap.put(node.getNodeId(), node);
            if (node.getParentId() == null) {
                root = node;
            }
        }
        
        for (DecisionNode node : allNodes) {
            if (node.getParentId() != null) {
                DecisionNode parent = nodeMap.get(node.getParentId());
                if (parent != null) {
                    parent.addChild(node);
                }
            }
        }
        
        return root;
    }

    public DecisionNode getNodeById(int nodeId) {
        String sql = "SELECT * FROM decision_nodes WHERE node_id = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, nodeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapNode(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<DecisionNode> getChildNodes(int parentId) {
        List<DecisionNode> nodes = new ArrayList<>();
        String sql = "SELECT * FROM decision_nodes WHERE parent_id = ? ORDER BY node_id";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, parentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    nodes.add(mapNode(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return nodes;
    }

    public int addNode(int treeId, Integer parentId, String nodeText, String optionLabel, String nodeType) {
        String sql = "INSERT INTO decision_nodes (tree_id, parent_id, node_text, option_label, node_type) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, treeId);
            if (parentId == null) {
                ps.setNull(2, Types.INTEGER);
            } else {
                ps.setInt(2, parentId);
            }
            ps.setString(3, nodeText);
            ps.setString(4, optionLabel);
            ps.setString(5, nodeType);
            
            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean updateNode(int nodeId, String nodeText, String optionLabel, String nodeType) {
        String sql = "UPDATE decision_nodes SET node_text = ?, option_label = ?, node_type = ? WHERE node_id = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, nodeText);
            ps.setString(2, optionLabel);
            ps.setString(3, nodeType);
            ps.setInt(4, nodeId);
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteNode(int nodeId) {
        // Cascade delete is handled by FK constraint
        String sql = "DELETE FROM decision_nodes WHERE node_id = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, nodeId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // =============== RATING OPERATIONS ===============

    public boolean addOrUpdateRating(int treeId, int userId, int rating) {
        String checkSql = "SELECT rating_id FROM decision_tree_ratings WHERE tree_id = ? AND user_id = ?";
        String insertSql = "INSERT INTO decision_tree_ratings (tree_id, user_id, rating) VALUES (?, ?, ?)";
        String updateSql = "UPDATE decision_tree_ratings SET rating = ? WHERE tree_id = ? AND user_id = ?";
        
        try (Connection con = DBConnection.getConnection()) {
            boolean exists = false;
            
            try (PreparedStatement ps = con.prepareStatement(checkSql)) {
                ps.setInt(1, treeId);
                ps.setInt(2, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    exists = rs.next();
                }
            }
            
            if (exists) {
                try (PreparedStatement ps = con.prepareStatement(updateSql)) {
                    ps.setInt(1, rating);
                    ps.setInt(2, treeId);
                    ps.setInt(3, userId);
                    ps.executeUpdate();
                }
            } else {
                try (PreparedStatement ps = con.prepareStatement(insertSql)) {
                    ps.setInt(1, treeId);
                    ps.setInt(2, userId);
                    ps.setInt(3, rating);
                    ps.executeUpdate();
                }
            }
            
            // Update average rating
            updateTreeAverageRating(treeId, con);
            return true;
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public int getUserRating(int treeId, int userId) {
        String sql = "SELECT rating FROM decision_tree_ratings WHERE tree_id = ? AND user_id = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, treeId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("rating");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    private void updateTreeAverageRating(int treeId, Connection con) throws SQLException {
        String sql = "UPDATE decision_trees SET " +
                     "avg_rating = (SELECT COALESCE(AVG(rating), 0) FROM decision_tree_ratings WHERE tree_id = ?), " +
                     "rating_count = (SELECT COUNT(*) FROM decision_tree_ratings WHERE tree_id = ?) " +
                     "WHERE tree_id = ?";
        
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, treeId);
            ps.setInt(2, treeId);
            ps.setInt(3, treeId);
            ps.executeUpdate();
        }
    }

    // =============== HELPER METHODS ===============

    private DecisionTree mapTree(ResultSet rs) throws SQLException {
        DecisionTree tree = new DecisionTree();
        tree.setTreeId(rs.getInt("tree_id"));
        tree.setUserId(rs.getInt("user_id"));
        tree.setSubcategoryId(rs.getInt("subcategory_id"));
        tree.setTreeName(rs.getString("tree_name"));
        tree.setDescription(rs.getString("description"));
        tree.setAvgRating(rs.getDouble("avg_rating"));
        tree.setRatingCount(rs.getInt("rating_count"));
        tree.setCreatedAt(rs.getTimestamp("created_at"));
        tree.setUpdatedAt(rs.getTimestamp("updated_at"));
        tree.setCreatorUsername(rs.getString("username"));
        tree.setCategoryName(rs.getString("category_name"));
        tree.setSubcategoryName(rs.getString("subcategory_name"));
        return tree;
    }

    private DecisionNode mapNode(ResultSet rs) throws SQLException {
        DecisionNode node = new DecisionNode();
        node.setNodeId(rs.getInt("node_id"));
        node.setTreeId(rs.getInt("tree_id"));
        int parentId = rs.getInt("parent_id");
        node.setParentId(rs.wasNull() ? null : parentId);
        node.setNodeText(rs.getString("node_text"));
        node.setOptionLabel(rs.getString("option_label"));
        node.setNodeType(rs.getString("node_type"));
        node.setCreatedAt(rs.getTimestamp("created_at"));
        node.setUpdatedAt(rs.getTimestamp("updated_at"));
        return node;
    }
}
