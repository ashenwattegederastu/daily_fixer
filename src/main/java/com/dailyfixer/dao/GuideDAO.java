package com.dailyfixer.dao;

import java.sql.*;
import java.util.*;
import com.dailyfixer.model.*;
import com.dailyfixer.util.DBConnection;

public class GuideDAO {

    // Add Guide + Requirements + Steps with Images
    public int addGuide(Guide guide, List<String> requirements, List<GuideStep> steps) {
        String guideSQL = "INSERT INTO guides (title, main_image, main_category, sub_category, youtube_url, created_by, created_role) VALUES (?, ?, ?, ?, ?, ?, ?)";
        String reqSQL = "INSERT INTO guide_requirements (guide_id, requirement) VALUES (?, ?)";
        String stepSQL = "INSERT INTO guide_steps (guide_id, step_order, step_title, step_body) VALUES (?, ?, ?, ?)";
        String stepImageSQL = "INSERT INTO guide_step_images (step_id, image_data) VALUES (?, ?)";

        int guideId = 0;
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            // Insert guide
            try (PreparedStatement ps = conn.prepareStatement(guideSQL, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, guide.getTitle());
                ps.setBytes(2, guide.getMainImage());
                ps.setString(3, guide.getMainCategory());
                ps.setString(4, guide.getSubCategory());
                ps.setString(5, guide.getYoutubeUrl());
                ps.setInt(6, guide.getCreatedBy());
                ps.setString(7, guide.getCreatedRole());
                ps.executeUpdate();

                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    guideId = rs.getInt(1);
                }
            }

            // Insert requirements
            try (PreparedStatement psReq = conn.prepareStatement(reqSQL)) {
                for (String req : requirements) {
                    if (req != null && !req.trim().isEmpty()) {
                        psReq.setInt(1, guideId);
                        psReq.setString(2, req.trim());
                        psReq.addBatch();
                    }
                }
                psReq.executeBatch();
            }

            // Insert steps and their images
            try (PreparedStatement psStep = conn.prepareStatement(stepSQL, Statement.RETURN_GENERATED_KEYS);
                 PreparedStatement psStepImage = conn.prepareStatement(stepImageSQL)) {
                int stepOrder = 1;
                for (GuideStep step : steps) {
                    if (step.getStepTitle() != null && !step.getStepTitle().trim().isEmpty()) {
                        psStep.setInt(1, guideId);
                        psStep.setInt(2, stepOrder++);
                        psStep.setString(3, step.getStepTitle());
                        psStep.setString(4, step.getStepBody());
                        psStep.executeUpdate();

                        ResultSet stepRs = psStep.getGeneratedKeys();
                        int stepId = 0;
                        if (stepRs.next()) {
                            stepId = stepRs.getInt(1);
                        }

                        // Insert step images
                        if (step.getImages() != null && stepId > 0) {
                            for (byte[] imageData : step.getImages()) {
                                if (imageData != null && imageData.length > 0) {
                                    psStepImage.setInt(1, stepId);
                                    psStepImage.setBytes(2, imageData);
                                    psStepImage.addBatch();
                                }
                            }
                            psStepImage.executeBatch();
                        }
                    }
                }
            }

            conn.commit();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return guideId;
    }

    // Update Guide
    public void updateGuide(Guide guide, List<String> requirements, List<GuideStep> steps) {
        String updateGuideSQL = "UPDATE guides SET title=?, main_image=?, main_category=?, sub_category=?, youtube_url=? WHERE guide_id=?";
        String deleteReqSQL = "DELETE FROM guide_requirements WHERE guide_id=?";
        String deleteStepsSQL = "DELETE FROM guide_steps WHERE guide_id=?";
        String reqSQL = "INSERT INTO guide_requirements (guide_id, requirement) VALUES (?, ?)";
        String stepSQL = "INSERT INTO guide_steps (guide_id, step_order, step_title, step_body) VALUES (?, ?, ?, ?)";
        String stepImageSQL = "INSERT INTO guide_step_images (step_id, image_data) VALUES (?, ?)";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            // Update guide basic info
            try (PreparedStatement ps = conn.prepareStatement(updateGuideSQL)) {
                ps.setString(1, guide.getTitle());
                ps.setBytes(2, guide.getMainImage());
                ps.setString(3, guide.getMainCategory());
                ps.setString(4, guide.getSubCategory());
                ps.setString(5, guide.getYoutubeUrl());
                ps.setInt(6, guide.getGuideId());
                ps.executeUpdate();
            }

            // Delete old requirements and steps
            try (PreparedStatement psDelReq = conn.prepareStatement(deleteReqSQL);
                 PreparedStatement psDelSteps = conn.prepareStatement(deleteStepsSQL)) {
                psDelReq.setInt(1, guide.getGuideId());
                psDelReq.executeUpdate();
                psDelSteps.setInt(1, guide.getGuideId());
                psDelSteps.executeUpdate();
            }

            // Insert new requirements
            try (PreparedStatement psReq = conn.prepareStatement(reqSQL)) {
                for (String req : requirements) {
                    if (req != null && !req.trim().isEmpty()) {
                        psReq.setInt(1, guide.getGuideId());
                        psReq.setString(2, req.trim());
                        psReq.addBatch();
                    }
                }
                psReq.executeBatch();
            }

            // Insert new steps and their images
            try (PreparedStatement psStep = conn.prepareStatement(stepSQL, Statement.RETURN_GENERATED_KEYS);
                 PreparedStatement psStepImage = conn.prepareStatement(stepImageSQL)) {
                int stepOrder = 1;
                for (GuideStep step : steps) {
                    if (step.getStepTitle() != null && !step.getStepTitle().trim().isEmpty()) {
                        psStep.setInt(1, guide.getGuideId());
                        psStep.setInt(2, stepOrder++);
                        psStep.setString(3, step.getStepTitle());
                        psStep.setString(4, step.getStepBody());
                        psStep.executeUpdate();

                        ResultSet stepRs = psStep.getGeneratedKeys();
                        int stepId = 0;
                        if (stepRs.next()) {
                            stepId = stepRs.getInt(1);
                        }

                        if (step.getImages() != null && stepId > 0) {
                            for (byte[] imageData : step.getImages()) {
                                if (imageData != null && imageData.length > 0) {
                                    psStepImage.setInt(1, stepId);
                                    psStepImage.setBytes(2, imageData);
                                    psStepImage.addBatch();
                                }
                            }
                            psStepImage.executeBatch();
                        }
                    }
                }
            }

            conn.commit();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Delete Guide
    public void deleteGuide(int guideId) {
        String sql = "DELETE FROM guides WHERE guide_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, guideId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Get all guides
    public List<Guide> getAllGuides() {
        List<Guide> list = new ArrayList<>();
        String sql = "SELECT g.*, u.first_name, u.last_name FROM guides g LEFT JOIN users u ON g.created_by = u.user_id ORDER BY g.guide_id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Guide g = mapGuideFromResultSet(rs);
                g.setCreatorName(rs.getString("first_name") + " " + rs.getString("last_name"));
                list.add(g);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Get guides by creator
    public List<Guide> getGuidesByCreator(int userId) {
        List<Guide> list = new ArrayList<>();
        String sql = "SELECT g.*, u.first_name, u.last_name FROM guides g LEFT JOIN users u ON g.created_by = u.user_id WHERE g.created_by=? ORDER BY g.guide_id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Guide g = mapGuideFromResultSet(rs);
                g.setCreatorName(rs.getString("first_name") + " " + rs.getString("last_name"));
                list.add(g);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Search and filter guides
    public List<Guide> searchGuides(String keyword, String mainCategory, String subCategory) {
        List<Guide> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT g.*, u.first_name, u.last_name FROM guides g LEFT JOIN users u ON g.created_by = u.user_id WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (g.title LIKE ? OR g.main_category LIKE ? OR g.sub_category LIKE ?)");
            String likeKeyword = "%" + keyword.trim() + "%";
            params.add(likeKeyword);
            params.add(likeKeyword);
            params.add(likeKeyword);
        }
        if (mainCategory != null && !mainCategory.trim().isEmpty()) {
            sql.append(" AND g.main_category = ?");
            params.add(mainCategory.trim());
        }
        if (subCategory != null && !subCategory.trim().isEmpty()) {
            sql.append(" AND g.sub_category = ?");
            params.add(subCategory.trim());
        }
        sql.append(" ORDER BY g.guide_id DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Guide g = mapGuideFromResultSet(rs);
                g.setCreatorName(rs.getString("first_name") + " " + rs.getString("last_name"));
                list.add(g);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Get a single guide by ID (with requirements and steps)
    public Guide getGuideById(int guideId) {
        Guide guide = null;
        try (Connection conn = DBConnection.getConnection()) {
            // Guide main info
            String sql = "SELECT g.*, u.first_name, u.last_name FROM guides g LEFT JOIN users u ON g.created_by = u.user_id WHERE g.guide_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, guideId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        guide = mapGuideFromResultSet(rs);
                        guide.setCreatorName(rs.getString("first_name") + " " + rs.getString("last_name"));
                    }
                }
            }

            if (guide != null) {
                // Requirements
                String reqSql = "SELECT requirement FROM guide_requirements WHERE guide_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(reqSql)) {
                    ps.setInt(1, guideId);
                    try (ResultSet rs = ps.executeQuery()) {
                        List<String> requirements = new ArrayList<>();
                        while (rs.next()) {
                            requirements.add(rs.getString("requirement"));
                        }
                        guide.setRequirements(requirements);
                    }
                }

                // Steps with images
                String stepSql = "SELECT step_id, step_order, step_title, step_body FROM guide_steps WHERE guide_id = ? ORDER BY step_order";
                try (PreparedStatement ps = conn.prepareStatement(stepSql)) {
                    ps.setInt(1, guideId);
                    try (ResultSet rs = ps.executeQuery()) {
                        List<GuideStep> steps = new ArrayList<>();
                        while (rs.next()) {
                            GuideStep step = new GuideStep();
                            step.setStepId(rs.getInt("step_id"));
                            step.setGuideId(guideId);
                            step.setStepOrder(rs.getInt("step_order"));
                            step.setStepTitle(rs.getString("step_title"));
                            step.setStepBody(rs.getString("step_body"));
                            steps.add(step);
                        }
                        guide.setSteps(steps);
                    }
                }

                // Get rating counts
                int[] ratings = getRatingCounts(guideId);
                guide.setUpVotes(ratings[0]);
                guide.setDownVotes(ratings[1]);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return guide;
    }

    // Get step image IDs for a step
    public List<Integer> getStepImageIds(int stepId) {
        List<Integer> ids = new ArrayList<>();
        String sql = "SELECT image_id FROM guide_step_images WHERE step_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, stepId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ids.add(rs.getInt("image_id"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ids;
    }

    // Get step image by ID
    public byte[] getStepImage(int imageId) {
        String sql = "SELECT image_data FROM guide_step_images WHERE image_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, imageId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getBytes("image_data");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Rating methods
    public void addOrUpdateRating(int guideId, int userId, String rating) {
        String checkSql = "SELECT rating_id FROM guide_ratings WHERE guide_id = ? AND user_id = ?";
        String insertSql = "INSERT INTO guide_ratings (guide_id, user_id, rating) VALUES (?, ?, ?)";
        String updateSql = "UPDATE guide_ratings SET rating = ? WHERE guide_id = ? AND user_id = ?";

        try (Connection conn = DBConnection.getConnection()) {
            boolean exists = false;
            try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
                ps.setInt(1, guideId);
                ps.setInt(2, userId);
                ResultSet rs = ps.executeQuery();
                exists = rs.next();
            }

            if (exists) {
                try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                    ps.setString(1, rating);
                    ps.setInt(2, guideId);
                    ps.setInt(3, userId);
                    ps.executeUpdate();
                }
            } else {
                try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                    ps.setInt(1, guideId);
                    ps.setInt(2, userId);
                    ps.setString(3, rating);
                    ps.executeUpdate();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public String getUserRating(int guideId, int userId) {
        String sql = "SELECT rating FROM guide_ratings WHERE guide_id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, guideId);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("rating");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public int[] getRatingCounts(int guideId) {
        int upVotes = 0;
        int downVotes = 0;
        String sql = "SELECT rating, COUNT(*) as cnt FROM guide_ratings WHERE guide_id = ? GROUP BY rating";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, guideId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String rating = rs.getString("rating");
                int count = rs.getInt("cnt");
                if ("UP".equals(rating)) {
                    upVotes = count;
                } else if ("DOWN".equals(rating)) {
                    downVotes = count;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new int[]{upVotes, downVotes};
    }

    // Comment methods
    public void addComment(int guideId, int userId, String comment) {
        String sql = "INSERT INTO guide_comments (guide_id, user_id, comment) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, guideId);
            ps.setInt(2, userId);
            ps.setString(3, comment);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteComment(int commentId, int userId) {
        // Only delete if the user owns the comment
        String sql = "DELETE FROM guide_comments WHERE comment_id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, commentId);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<GuideComment> getComments(int guideId) {
        List<GuideComment> comments = new ArrayList<>();
        String sql = "SELECT c.*, u.first_name, u.last_name FROM guide_comments c LEFT JOIN users u ON c.user_id = u.user_id WHERE c.guide_id = ? ORDER BY c.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, guideId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                GuideComment comment = new GuideComment();
                comment.setCommentId(rs.getInt("comment_id"));
                comment.setGuideId(rs.getInt("guide_id"));
                comment.setUserId(rs.getInt("user_id"));
                comment.setComment(rs.getString("comment"));
                comment.setCreatedAt(rs.getTimestamp("created_at"));
                comment.setUserName(rs.getString("first_name") + " " + rs.getString("last_name"));
                comments.add(comment);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return comments;
    }

    // Check if user can edit/delete guide
    public boolean canUserModifyGuide(int guideId, int userId, String userRole) {
        if ("admin".equalsIgnoreCase(userRole)) {
            return true; // Admin can modify any guide
        }
        String sql = "SELECT created_by FROM guides WHERE guide_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, guideId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("created_by") == userId;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Helper method to map ResultSet to Guide
    private Guide mapGuideFromResultSet(ResultSet rs) throws SQLException {
        Guide g = new Guide();
        g.setGuideId(rs.getInt("guide_id"));
        g.setTitle(rs.getString("title"));
        g.setMainImage(rs.getBytes("main_image"));
        g.setMainCategory(rs.getString("main_category"));
        g.setSubCategory(rs.getString("sub_category"));
        g.setYoutubeUrl(rs.getString("youtube_url"));
        g.setCreatedBy(rs.getInt("created_by"));
        g.setCreatedRole(rs.getString("created_role"));
        g.setCreatedAt(rs.getTimestamp("created_at"));
        return g;
    }
}
