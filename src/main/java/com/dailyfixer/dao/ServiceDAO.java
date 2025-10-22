package com.dailyfixer.dao;

import com.dailyfixer.model.Service;
import com.dailyfixer.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ServiceDAO {

    // Insert new service
    public void addService(Service s) throws Exception {
        String sql = "INSERT INTO services (technician_id, service_name, description, category, pricing_type, fixed_rate, hourly_rate, inspection_charge, transport_charge, available_dates, service_image, image_type) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, s.getTechnicianId());
            ps.setString(2, s.getServiceName());
            ps.setString(3, s.getDescription());
            ps.setString(4, s.getCategory());
            ps.setString(5, s.getPricingType());
            ps.setObject(6, s.getFixedRate() == 0 ? null : s.getFixedRate());
            ps.setObject(7, s.getHourlyRate() == 0 ? null : s.getHourlyRate());
            ps.setObject(8, s.getInspectionCharge());
            ps.setObject(9, s.getTransportCharge());
            ps.setString(10, s.getAvailableDates());
            ps.setBytes(11, s.getServiceImage());
            ps.setString(12, s.getImageType());
            ps.executeUpdate();
        }
    }

    public Service getServiceById(int serviceId) throws Exception {
        String sql = "SELECT * FROM services WHERE service_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, serviceId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Service s = new Service();
                    s.setServiceId(rs.getInt("service_id"));
                    s.setTechnicianId(rs.getInt("technician_id"));
                    s.setServiceName(rs.getString("service_name"));
                    s.setDescription(rs.getString("description"));
                    s.setCategory(rs.getString("category"));
                    s.setPricingType(rs.getString("pricing_type"));
                    s.setFixedRate(rs.getDouble("fixed_rate"));
                    s.setHourlyRate(rs.getDouble("hourly_rate"));
                    s.setInspectionCharge(rs.getDouble("inspection_charge"));
                    s.setTransportCharge(rs.getDouble("transport_charge"));
                    s.setAvailableDates(rs.getString("available_dates"));
                    s.setServiceImage(rs.getBytes("service_image"));
                    s.setImageType(rs.getString("image_type"));
                    return s;
                }
            }
        }
        return null;
    }

    public void updateService(Service service) throws Exception {
        String sql = "UPDATE services SET service_name=?, description=?, category=?, pricing_type=?, fixed_rate=?, hourly_rate=?, inspection_charge=?, transport_charge=?, available_dates=?, service_image=?, image_type=? WHERE service_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, service.getServiceName());
            ps.setString(2, service.getDescription());
            ps.setString(3, service.getCategory());
            ps.setString(4, service.getPricingType());
            ps.setDouble(5, service.getFixedRate());
            ps.setDouble(6, service.getHourlyRate());
            ps.setDouble(7, service.getInspectionCharge());
            ps.setDouble(8, service.getTransportCharge());
            ps.setString(9, service.getAvailableDates());
            ps.setBytes(10, service.getServiceImage());
            ps.setString(11, service.getImageType());
            ps.setInt(12, service.getServiceId());
            ps.executeUpdate();
        }
    }


    // Retrieve all services by technician
    public List<Service> getServicesByTechnician(int technicianId) throws Exception {
        List<Service> list = new ArrayList<>();
        String sql = "SELECT * FROM services WHERE technician_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, technicianId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Service s = new Service();
                s.setServiceId(rs.getInt("service_id"));
                s.setTechnicianId(rs.getInt("technician_id"));
                s.setServiceName(rs.getString("service_name"));
                s.setDescription(rs.getString("description"));
                s.setCategory(rs.getString("category"));
                s.setPricingType(rs.getString("pricing_type"));
                s.setFixedRate(rs.getDouble("fixed_rate"));
                s.setHourlyRate(rs.getDouble("hourly_rate"));
                s.setInspectionCharge(rs.getDouble("inspection_charge"));
                s.setTransportCharge(rs.getDouble("transport_charge"));
                s.setAvailableDates(rs.getString("available_dates"));
                s.setImageType(rs.getString("image_type"));
                list.add(s);
            }
        }
        return list;
    }

    // Get single service image
    public Service getServiceImage(int serviceId) throws Exception {
        String sql = "SELECT service_image, image_type FROM services WHERE service_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, serviceId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Service s = new Service();
                s.setServiceImage(rs.getBytes("service_image"));
                s.setImageType(rs.getString("image_type"));
                return s;
            }
        }
        return null;
    }

    // Delete
    public void deleteService(int serviceId) throws Exception {
        String sql = "DELETE FROM services WHERE service_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, serviceId);
            ps.executeUpdate();
        }
    }

}
