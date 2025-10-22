package com.dailyfixer.guidewrite;

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

        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/dailyfixer","root","")) {
            String sql = "SELECT image FROM guide_steps WHERE step_id = ?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, stepId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        byte[] img = rs.getBytes("image");
                        if (img != null) {
                            response.setContentType("image/jpeg");
                            response.getOutputStream().write(img);
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
