package com.healthcare.dao;

import com.healthcare.model.Appointment;
import com.healthcare.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
/**
 * Data Access Object for Appointment operations
 * Handles all database operations related to appointments
 */
public class AppointmentDAO {
    
    /**
     * Book a new appointment
     * @param appointment Appointment object to book
     * @return true if booked successfully
     */
    public boolean bookAppointment(Appointment appointment) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            // Insert appointment
            String sql = "INSERT INTO appointments (user_id, doctor_id, appointment_date, time_slot, status, reason) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            
            pstmt.setInt(1, appointment.getUserId());
            pstmt.setInt(2, appointment.getDoctorId());
            pstmt.setDate(3, appointment.getAppointmentDate());
            pstmt.setString(4, appointment.getTimeSlot());
            pstmt.setString(5, "scheduled");
            pstmt.setString(6, appointment.getReason());
            
            int result = pstmt.executeUpdate();
            
            // Mark availability slot as booked
            String updateAvailability = "UPDATE doctor_availability SET is_booked = TRUE WHERE doctor_id = ? AND available_date = ? AND time_slot = ?";
            PreparedStatement pstmt2 = conn.prepareStatement(updateAvailability);
            pstmt2.setInt(1, appointment.getDoctorId());
            pstmt2.setDate(2, appointment.getAppointmentDate());
            pstmt2.setString(3, appointment.getTimeSlot());
            pstmt2.executeUpdate();
            
            conn.commit();
            pstmt.close();
            pstmt2.close();
            
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("Error booking appointment: " + e.getMessage());
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
    
    /**
     * Get appointments for a specific user
     * @param userId User ID
     * @return List of appointments
     */
    public List<Appointment> getAppointmentsByUserId(int userId) {
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT a.*, d.doctor_name, d.specialization " +
                     "FROM appointments a " +
                     "JOIN doctors d ON a.doctor_id = d.id " +
                     "WHERE a.user_id = ? " +
                     "ORDER BY a.appointment_date DESC, a.time_slot";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Appointment appointment = new Appointment();
                appointment.setId(rs.getInt("id"));
                appointment.setUserId(rs.getInt("user_id"));
                appointment.setDoctorId(rs.getInt("doctor_id"));
                appointment.setAppointmentDate(rs.getDate("appointment_date"));
                appointment.setTimeSlot(rs.getString("time_slot"));
                appointment.setStatus(rs.getString("status"));
                appointment.setReason(rs.getString("reason"));
                appointment.setCreatedAt(rs.getTimestamp("created_at"));
                appointment.setDoctorName(rs.getString("doctor_name"));
                appointment.setSpecialization(rs.getString("specialization"));
                appointments.add(appointment);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting appointments: " + e.getMessage());
        }
        
        return appointments;
    }
    
    /**
     * Get all appointments (for admin)
     * @return List of all appointments
     */
    public List<Appointment> getAllAppointments() {
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT a.*, u.name as patient_name, d.doctor_name, d.specialization " +
                     "FROM appointments a " +
                     "JOIN users u ON a.user_id = u.id " +
                     "JOIN doctors d ON a.doctor_id = d.id " +
                     "ORDER BY a.appointment_date DESC, a.time_slot";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Appointment appointment = new Appointment();
                appointment.setId(rs.getInt("id"));
                appointment.setUserId(rs.getInt("user_id"));
                appointment.setDoctorId(rs.getInt("doctor_id"));
                appointment.setAppointmentDate(rs.getDate("appointment_date"));
                appointment.setTimeSlot(rs.getString("time_slot"));
                appointment.setStatus(rs.getString("status"));
                appointment.setReason(rs.getString("reason"));
                appointment.setCreatedAt(rs.getTimestamp("created_at"));
                appointment.setPatientName(rs.getString("patient_name"));
                appointment.setDoctorName(rs.getString("doctor_name"));
                appointment.setSpecialization(rs.getString("specialization"));
                appointments.add(appointment);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting all appointments: " + e.getMessage());
        }
        
        return appointments;
    }
    
    /**
     * Cancel an appointment
     * @param appointmentId Appointment ID to cancel
     * @return true if cancelled successfully
     */
    public boolean cancelAppointment(int appointmentId) {
        String sql = "UPDATE appointments SET status = 'cancelled' WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, appointmentId);
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("Error cancelling appointment: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Get appointment count for a user
     * @param userId User ID
     * @return Count of appointments
     */
    public int getAppointmentCount(int userId) {
        String sql = "SELECT COUNT(*) FROM appointments WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting appointment count: " + e.getMessage());
        }
        return 0;
    }
    
    /**
     * Cancel appointment and release the corresponding doctor availability slot
     * @param appointmentId Appointment ID
     * @return true if successful
     */
    public boolean cancelAppointmentAndReleaseSlot(int appointmentId) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            // Get appointment details first
            String selectSql = "SELECT doctor_id, appointment_date, time_slot FROM appointments WHERE id = ?";
            PreparedStatement selectPstmt = conn.prepareStatement(selectSql);
            selectPstmt.setInt(1, appointmentId);
            ResultSet rs = selectPstmt.executeQuery();
            
            int doctorId = -1;
            Date apptDate = null;
            String timeSlot = null;
            
            if (rs.next()) {
                doctorId = rs.getInt("doctor_id");
                apptDate = rs.getDate("appointment_date");
                timeSlot = rs.getString("time_slot");
            }
            rs.close();
            selectPstmt.close();
            
            if (doctorId != -1 && apptDate != null && timeSlot != null) {
                // Update appointment status to cancelled
                String updateApptSql = "UPDATE appointments SET status = 'cancelled' WHERE id = ?";
                PreparedStatement updateApptPstmt = conn.prepareStatement(updateApptSql);
                updateApptPstmt.setInt(1, appointmentId);
                updateApptPstmt.executeUpdate();
                updateApptPstmt.close();
                
                // Release the slot in doctor_availability
                String releaseSlotSql = "UPDATE doctor_availability SET is_booked = FALSE WHERE doctor_id = ? AND available_date = ? AND time_slot = ?";
                PreparedStatement releaseSlotPstmt = conn.prepareStatement(releaseSlotSql);
                releaseSlotPstmt.setInt(1, doctorId);
                releaseSlotPstmt.setDate(2, apptDate);
                releaseSlotPstmt.setString(3, timeSlot);
                releaseSlotPstmt.executeUpdate();
                releaseSlotPstmt.close();
                
                conn.commit();
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("Error cancelling appointment and releasing slot: " + e.getMessage());
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        return false;
    }
    
    /**
     * Update appointment status
     * @param appointmentId Appointment ID
     * @param status New status
     * @return true if successful
     */
    public boolean updateAppointmentStatus(int appointmentId, String status) {
        String sql = "UPDATE appointments SET status = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status);
            pstmt.setInt(2, appointmentId);
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating appointment status: " + e.getMessage());
            return false;
        }
    }
}