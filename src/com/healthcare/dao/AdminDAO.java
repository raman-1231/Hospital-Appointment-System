package com.healthcare.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import com.healthcare.util.DBConnection;

/**
 * Data Access Object for Admin operations
 * Handles admin authentication
 */
public class AdminDAO {
    
    /**
     * Validate admin login credentials
     * @param email Admin email
     * @param password Admin password
     * @return true if valid admin
     */
    public boolean validateAdmin(String email, String password) {
        String sql = "SELECT * FROM admins WHERE email = ? AND password = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, email);
            pstmt.setString(2, password);
            
            ResultSet rs = pstmt.executeQuery();
            return rs.next();
            
        } catch (SQLException e) {
            System.err.println("Error validating admin: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get admin name by email
     * @param email Admin email
     * @return Admin name
     */
    public String getAdminName(String email) {
        String sql = "SELECT name FROM admins WHERE email = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getString("name");
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting admin name: " + e.getMessage());
        }
        
        return "Admin";
    }
}
