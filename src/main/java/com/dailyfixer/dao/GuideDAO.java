package com.dailyfixer.dao;

import java.sql.*;
import java.util.*;
import com.dailyfixer.model.*;
import com.dailyfixer.util.DBConnection;

public class GuideDAO {

    // Add Guide + Requirements + Steps
    public void addGuide(Guide guide, List<String> requirements, List<GuideStep> steps) {
        String guideSQL = "INSERT INTO guides (volunteer_id, title, main_image) VALUES (?, ?, ?)";
        String reqSQL = "INSERT INTO guide_requirements (guide_id, requirement) VALUES (?, ?)";
        String stepSQL = "INSERT INTO guide_steps (guide_id, step_title, step_description, step_image) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            // Insert guide
            PreparedStatement ps = conn.prepareStatement(guideSQL, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, guide.getVolunteerId());
            ps.setString(2, guide.getTitle());
            ps.setBytes(3, guide.getMainImage());
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            int guideId = 0;
            if (rs.next()) {
                guideId = rs.getInt(1);
            }

            // Insert requirements
            PreparedStatement psReq = conn.prepareStatement(reqSQL);
            for (String req : requirements) {
                psReq.setInt(1, guideId);
                psReq.setString(2, req);
                psReq.addBatch();
            }
            psReq.executeBatch();

            // Insert steps
            PreparedStatement psStep = conn.prepareStatement(stepSQL);
            for (GuideStep step : steps) {
                psStep.setInt(1, guideId);
                psStep.setString(2, step.getStepTitle());
                psStep.setString(3, step.getStepDescription());
                psStep.setBytes(4, step.getStepImage());
                psStep.addBatch();
            }
            psStep.executeBatch();

            conn.commit();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Get all guides
    public List<Guide> getAllGuides() {
        List<Guide> list = new ArrayList<>();
        String sql = "SELECT * FROM guides ORDER BY guide_id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Guide g = new Guide();
                g.setGuideId(rs.getInt("guide_id"));
                g.setVolunteerId(rs.getInt("volunteer_id"));
                g.setTitle(rs.getString("title"));
                g.setMainImage(rs.getBytes("main_image"));
                list.add(g);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Get guides by volunteer
    public List<Guide> getGuidesByVolunteer(int volunteerId) {
        List<Guide> list = new ArrayList<>();
        String sql = "SELECT * FROM guides WHERE volunteer_id=? ORDER BY guide_id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, volunteerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Guide g = new Guide();
                g.setGuideId(rs.getInt("guide_id"));
                g.setVolunteerId(rs.getInt("volunteer_id"));
                g.setTitle(rs.getString("title"));
                g.setMainImage(rs.getBytes("main_image"));
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
            String sql = "SELECT guide_id, volunteer_id, title, main_image FROM guides WHERE guide_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, guideId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        guide = new Guide();
                        guide.setGuideId(rs.getInt("guide_id"));
                        guide.setVolunteerId(rs.getInt("volunteer_id"));
                        guide.setTitle(rs.getString("title"));
                        guide.setMainImage(rs.getBytes("main_image"));
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

                // Steps
                String stepSql = "SELECT step_id, step_title, step_description, step_image FROM guide_steps WHERE guide_id = ? ORDER BY step_id";
                try (PreparedStatement ps = conn.prepareStatement(stepSql)) {
                    ps.setInt(1, guideId);
                    try (ResultSet rs = ps.executeQuery()) {
                        List<GuideStep> steps = new ArrayList<>();
                        while (rs.next()) {
                            GuideStep step = new GuideStep(
                                    rs.getInt("step_id"),
                                    rs.getString("step_title"),
                                    rs.getString("step_description"),
                                    rs.getBytes("step_image")
                            );
                            steps.add(step);
                        }
                        guide.setSteps(steps);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return guide;
    }
}
