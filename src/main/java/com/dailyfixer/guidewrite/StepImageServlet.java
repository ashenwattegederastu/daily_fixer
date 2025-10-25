package com.dailyfixer.guidewrite;

import com.dailyfixer.util.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.*;

@WebServlet("/StepImageServlet")
public class StepImageServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String stepIdStr = request.getParameter("id");
        if (stepIdStr == null) return;

        int stepId = Integer.parseInt(stepIdStr);

        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT step_image FROM guide_steps WHERE step_id = ?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, stepId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        byte[] img = rs.getBytes("step_image");
                        if (img != null) {
                            response.setContentType("image/jpeg");
                            response.getOutputStream().write(img);
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
