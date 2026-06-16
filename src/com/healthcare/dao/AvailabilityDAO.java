package com.healthcare.dao;

import com.healthcare.model.DoctorAvailability;
import com.healthcare.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
/**
 * Data Access Object for Doctor Availability operations
 * Handles all database operations related to doctor availability
 */
public class AvailabilityDAO {
    
    /**
     * Get available time slots for a doctor on a specific date
     * @param doctorId Doctor ID
     * @param date Appointment date
     * @return List of available time slots
     */
    public List<DoctorAvailability> getAvailableSlots(int doctorId, Date date) {
        List<DoctorAvailability> slots = new ArrayList<>();
        String sql = "SELECT * FROM doctor_availability WHERE doctor_id = ? AND available_date = ? AND is_booked = FALSE ORDER BY time_slot";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, doctorId);
            pstmt.setDate(2, date);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                DoctorAvailability availability = new DoctorAvailability();
                availability.setId(rs.getInt("id"));
                availability.setDoctorId(rs.getInt("doctor_id"));
                availability.setAvailableDate(rs.getDate("available_date"));
                availability.setTimeSlot(rs.getString("time_slot"));
                availability.setBooked(rs.getBoolean("is_booked"));
                slots.add(availability);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting available slots: " + e.getMessage());
        }
        
        return slots;
    }
    
    /**
     * Get all availability for a doctor
     * @param doctorId Doctor ID
     * @return List of all availability slots
     */
    public List<DoctorAvailability> getDoctorAvailability(int doctorId) {
        List<DoctorAvailability> slots = new ArrayList<>();
        String sql = "SELECT * FROM doctor_availability WHERE doctor_id = ? AND available_date >= CURDATE() ORDER BY available_date, time_slot";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, doctorId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                DoctorAvailability availability = new DoctorAvailability();
                availability.setId(rs.getInt("id"));
                availability.setDoctorId(rs.getInt("doctor_id"));
                availability.setAvailableDate(rs.getDate("available_date"));
                availability.setTimeSlot(rs.getString("time_slot"));
                availability.setBooked(rs.getBoolean("is_booked"));
                slots.add(availability);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting doctor availability: " + e.getMessage());
        }
        
        return slots;
    }
    
    /**
     * Add availability slot for a doctor
     * @param availability DoctorAvailability object
     * @return true if added successfully
     */
    public boolean addAvailability(DoctorAvailability availability) {
        String sql = "INSERT INTO doctor_availability (doctor_id, available_date, time_slot, is_booked) VALUES (?, ?, ?, FALSE)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, availability.getDoctorId());
            pstmt.setDate(2, availability.getAvailableDate());
            pstmt.setString(3, availability.getTimeSlot());
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("Error adding availability: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Delete availability slot
     * @param availabilityId Availability ID
     * @return true if deleted successfully
     */
    public boolean deleteAvailability(int availabilityId) {
        String sql = "DELETE FROM doctor_availability WHERE id = ? AND is_booked = FALSE";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, availabilityId);
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting availability: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Check if time slot is available
     * @param doctorId Doctor ID
     * @param date Date
     * @param timeSlot Time slot
     * @return true if available
     */
    public boolean isSlotAvailable(int doctorId, Date date, String timeSlot) {
        String sql = "SELECT COUNT(*) FROM doctor_availability WHERE doctor_id = ? AND available_date = ? AND time_slot = ? AND is_booked = FALSE";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, doctorId);
            pstmt.setDate(2, date);
            pstmt.setString(3, timeSlot);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("Error checking slot availability: " + e.getMessage());
        }
        
        return false;
    }
    
    /**
     * Get available dates for a doctor
     * @param doctorId Doctor ID
     * @return List of dates with available slots
     */
    public List<Date> getAvailableDates(int doctorId) {
        List<Date> dates = new ArrayList<>();
        String sql = "SELECT DISTINCT available_date FROM doctor_availability WHERE doctor_id = ? AND available_date >= CURDATE() AND is_booked = FALSE ORDER BY available_date";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, doctorId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                dates.add(rs.getDate("available_date"));
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting available dates: " + e.getMessage());
        }
        
        return dates;
    }
    
    /**
     * Get all availability slots (including doctor names) for admin
     * @return List of all availability slots
     */
    public List<DoctorAvailability> getAllAvailabilities() {
        List<DoctorAvailability> slots = new ArrayList<>();
        String sql = "SELECT da.*, d.doctor_name " +
                     "FROM doctor_availability da " +
                     "JOIN doctors d ON da.doctor_id = d.id " +
                     "ORDER BY da.available_date DESC, da.time_slot";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                DoctorAvailability availability = new DoctorAvailability();
                availability.setId(rs.getInt("id"));
                availability.setDoctorId(rs.getInt("doctor_id"));
                availability.setAvailableDate(rs.getDate("available_date"));
                availability.setTimeSlot(rs.getString("time_slot"));
                availability.setBooked(rs.getBoolean("is_booked"));
                availability.setDoctorName(rs.getString("doctor_name"));
                slots.add(availability);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting all availabilities: " + e.getMessage());
        }
        
        return slots;
    }

    /**
     * Automatically generate availability slots for active doctors for the next 7 days.
     * Enforces that for any single date and time slot, at most 2 or 3 doctors are available.
     */
    public void generateUpcomingSlots() {
        String doctorsSql = "SELECT id FROM doctors WHERE status = 'active'";
        String checkSlotCountSql = "SELECT COUNT(*) FROM doctor_availability WHERE available_date = ? AND time_slot = ?";
        String checkDoctorSlotSql = "SELECT COUNT(*) FROM doctor_availability WHERE doctor_id = ? AND available_date = ? AND time_slot = ?";
        String insertSql = "INSERT IGNORE INTO doctor_availability (doctor_id, available_date, time_slot, is_booked) VALUES (?, ?, ?, FALSE)";
        
        String[] defaultSlots = {"09:00 AM", "10:00 AM", "11:00 AM", "02:00 PM", "03:00 PM", "04:00 PM"};
        java.util.Random random = new java.util.Random();
        
        try (Connection conn = DBConnection.getConnection()) {
            // Get all active doctors
            List<Integer> doctorIds = new ArrayList<>();
            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(doctorsSql)) {
                while (rs.next()) {
                    doctorIds.add(rs.getInt("id"));
                }
            }
            
            if (doctorIds.isEmpty()) return;
            
            // For the next 7 days (including today)
            long millisecondsInDay = 24 * 60 * 60 * 1000L;
            Date today = new Date(System.currentTimeMillis());
            
            try (PreparedStatement checkSlotCountPstmt = conn.prepareStatement(checkSlotCountSql);
                 PreparedStatement checkDoctorSlotPstmt = conn.prepareStatement(checkDoctorSlotSql);
                 PreparedStatement insertPstmt = conn.prepareStatement(insertSql)) {
                
                for (int i = 0; i < 7; i++) {
                    Date targetDate = new Date(today.getTime() + (i * millisecondsInDay));
                    
                    for (String slot : defaultSlots) {
                        // Check how many doctors are currently available at this date and time slot
                        checkSlotCountPstmt.setDate(1, targetDate);
                        checkSlotCountPstmt.setString(2, slot);
                        
                        int existingCount = 0;
                        try (ResultSet rs = checkSlotCountPstmt.executeQuery()) {
                            if (rs.next()) {
                                existingCount = rs.getInt(1);
                            }
                        }
                        
                        // Decide target count of doctors for this slot (randomly 2 or 3)
                        int targetCount = 2 + random.nextInt(2); // 2 or 3
                        
                        if (existingCount < targetCount) {
                            int slotsToGenerate = targetCount - existingCount;
                            
                            // Shuffle doctors to pick a random subset
                            List<Integer> shuffledDoctors = new ArrayList<>(doctorIds);
                            java.util.Collections.shuffle(shuffledDoctors);
                            
                            int generated = 0;
                            for (int doctorId : shuffledDoctors) {
                                if (generated >= slotsToGenerate) break;
                                
                                // Check if this specific doctor already has a slot on this date and time
                                checkDoctorSlotPstmt.setInt(1, doctorId);
                                checkDoctorSlotPstmt.setDate(2, targetDate);
                                checkDoctorSlotPstmt.setString(3, slot);
                                
                                boolean doctorHasSlot = false;
                                try (ResultSet rsDoc = checkDoctorSlotPstmt.executeQuery()) {
                                    if (rsDoc.next()) {
                                        doctorHasSlot = rsDoc.getInt(1) > 0;
                                    }
                                }
                                
                                if (!doctorHasSlot) {
                                    insertPstmt.setInt(1, doctorId);
                                    insertPstmt.setDate(2, targetDate);
                                    insertPstmt.setString(3, slot);
                                    insertPstmt.addBatch();
                                    generated++;
                                }
                            }
                        }
                    }
                }
                insertPstmt.executeBatch();
            }
            
        } catch (SQLException e) {
            System.err.println("Error generating upcoming slots: " + e.getMessage());
            e.printStackTrace();
        }
    }
}