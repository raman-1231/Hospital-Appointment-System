package com.healthcare.dao;

import com.healthcare.model.Doctor;
import com.healthcare.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
/**
 * Data Access Object for Doctor operations
 * Handles all database operations related to doctors
 */
public class DoctorDAO {
    
    /**
     * Get all active doctors
     * @return List of all active doctors
     */
    public List<Doctor> getAllDoctors() {
        List<Doctor> doctors = new ArrayList<>();
        String sql = "SELECT * FROM doctors WHERE status = 'active' ORDER BY doctor_name";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Doctor doctor = new Doctor();
                doctor.setId(rs.getInt("id"));
                doctor.setDoctorName(rs.getString("doctor_name"));
                doctor.setSpecialization(rs.getString("specialization"));
                doctor.setEmail(rs.getString("email"));
                doctor.setPhone(rs.getString("phone"));
                doctor.setExperienceYears(rs.getInt("experience_years"));
                doctor.setStatus(rs.getString("status"));
                doctor.setCreatedAt(rs.getTimestamp("created_at"));
                doctors.add(doctor);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting doctors: " + e.getMessage());
            e.printStackTrace();
        }
        
        return doctors;
    }
    
    /**
     * Get doctor by ID
     * @param doctorId Doctor ID
     * @return Doctor object
     */
    public Doctor getDoctorById(int doctorId) {
        String sql = "SELECT * FROM doctors WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, doctorId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Doctor doctor = new Doctor();
                doctor.setId(rs.getInt("id"));
                doctor.setDoctorName(rs.getString("doctor_name"));
                doctor.setSpecialization(rs.getString("specialization"));
                doctor.setEmail(rs.getString("email"));
                doctor.setPhone(rs.getString("phone"));
                doctor.setExperienceYears(rs.getInt("experience_years"));
                doctor.setStatus(rs.getString("status"));
                return doctor;
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting doctor: " + e.getMessage());
        }
        
        return null;
    }
    
    /**
     * Add a new doctor
     * @param doctor Doctor object to add
     * @return true if added successfully
     */
    public boolean addDoctor(Doctor doctor) {
        String sql = "INSERT INTO doctors (doctor_name, specialization, email, phone, experience_years, status) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, doctor.getDoctorName());
            pstmt.setString(2, doctor.getSpecialization());
            pstmt.setString(3, doctor.getEmail());
            pstmt.setString(4, doctor.getPhone());
            pstmt.setInt(5, doctor.getExperienceYears());
            pstmt.setString(6, "active");
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("Error adding doctor: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update doctor information
     * @param doctor Doctor object with updated info
     * @return true if updated successfully
     */
    public boolean updateDoctor(Doctor doctor) {
        String sql = "UPDATE doctors SET doctor_name = ?, specialization = ?, email = ?, phone = ?, experience_years = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, doctor.getDoctorName());
            pstmt.setString(2, doctor.getSpecialization());
            pstmt.setString(3, doctor.getEmail());
            pstmt.setString(4, doctor.getPhone());
            pstmt.setInt(5, doctor.getExperienceYears());
            pstmt.setInt(6, doctor.getId());
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating doctor: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Delete doctor (soft delete - set status to inactive)
     * @param doctorId Doctor ID to delete
     * @return true if deleted successfully
     */
    public boolean deleteDoctor(int doctorId) {
        String sql = "UPDATE doctors SET status = 'inactive' WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, doctorId);
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting doctor: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Get doctors by specialization
     * @param specialization Specialization to filter
     * @return List of doctors
     */
    public List<Doctor> getDoctorsBySpecialization(String specialization) {
        List<Doctor> doctors = new ArrayList<>();
        String sql = "SELECT * FROM doctors WHERE specialization = ? AND status = 'active' ORDER BY doctor_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, specialization);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Doctor doctor = new Doctor();
                doctor.setId(rs.getInt("id"));
                doctor.setDoctorName(rs.getString("doctor_name"));
                doctor.setSpecialization(rs.getString("specialization"));
                doctor.setEmail(rs.getString("email"));
                doctor.setPhone(rs.getString("phone"));
                doctor.setExperienceYears(rs.getInt("experience_years"));
                doctors.add(doctor);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting doctors by specialization: " + e.getMessage());
        }
        
        return doctors;
    }
}