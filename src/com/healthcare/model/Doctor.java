package com.healthcare.model;

import java.sql.Timestamp;

/**
 * Doctor Model Class
 * Represents a doctor in the healthcare system
 */
public class Doctor {
    private int id;
    private String doctorName;
    private String specialization;
    private String email;
    private String phone;
    private int experienceYears;
    private String status;
    private Timestamp createdAt;
    
    // Constructors
    public Doctor() {
    }
    
    public Doctor(String doctorName, String specialization, String email, String phone, int experienceYears) {
        this.doctorName = doctorName;
        this.specialization = specialization;
        this.email = email;
        this.phone = phone;
        this.experienceYears = experienceYears;
        this.status = "active";
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getDoctorName() {
        return doctorName;
    }
    
    public void setDoctorName(String doctorName) {
        this.doctorName = doctorName;
    }
    
    public String getSpecialization() {
        return specialization;
    }
    
    public void setSpecialization(String specialization) {
        this.specialization = specialization;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public int getExperienceYears() {
        return experienceYears;
    }
    
    public void setExperienceYears(int experienceYears) {
        this.experienceYears = experienceYears;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    @Override
    public String toString() {
        return "Doctor{" +
                "id=" + id +
                ", doctorName='" + doctorName + '\'' +
                ", specialization='" + specialization + '\'' +
                ", email='" + email + '\'' +
                ", experienceYears=" + experienceYears +
                ", status='" + status + '\'' +
                '}';
    }
}