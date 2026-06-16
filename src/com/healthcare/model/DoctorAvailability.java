package com.healthcare.model;

import java.sql.Date;

/**
 * Doctor Availability Model Class
 * Represents available time slots for doctors
 */
public class DoctorAvailability {
    private int id;
    private int doctorId;
    private Date availableDate;
    private String timeSlot;
    private boolean isBooked;
    private String doctorName;
    
    // Constructors
    public DoctorAvailability() {
    }
    
    public DoctorAvailability(int doctorId, Date availableDate, String timeSlot) {
        this.doctorId = doctorId;
        this.availableDate = availableDate;
        this.timeSlot = timeSlot;
        this.isBooked = false;
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getDoctorId() {
        return doctorId;
    }
    
    public void setDoctorId(int doctorId) {
        this.doctorId = doctorId;
    }
    
    public Date getAvailableDate() {
        return availableDate;
    }
    
    public void setAvailableDate(Date availableDate) {
        this.availableDate = availableDate;
    }
    
    public String getTimeSlot() {
        return timeSlot;
    }
    
    public void setTimeSlot(String timeSlot) {
        this.timeSlot = timeSlot;
    }
    
    public boolean isBooked() {
        return isBooked;
    }
    
    public void setBooked(boolean booked) {
        isBooked = booked;
    }

    public String getDoctorName() {
        return doctorName;
    }
    
    public void setDoctorName(String doctorName) {
        this.doctorName = doctorName;
    }
    
    @Override
    public String toString() {
        return "DoctorAvailability{" +
                "id=" + id +
                ", doctorId=" + doctorId +
                ", availableDate=" + availableDate +
                ", timeSlot='" + timeSlot + '\'' +
                ", isBooked=" + isBooked +
                '}';
    }
}