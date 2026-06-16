-- Smart Healthcare Appointment Management System Database Schema
CREATE DATABASE IF NOT EXISTS healthcare_db;
USE healthcare_db;

-- Drop tables if they exist to prevent conflicts (ordered by dependencies)
DROP TABLE IF EXISTS appointments;
DROP TABLE IF EXISTS doctor_availability;
DROP TABLE IF EXISTS admins;
DROP TABLE IF EXISTS doctors;
DROP TABLE IF EXISTS users;

-- Users table (Patients)
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Admins table
CREATE TABLE admins (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Doctors table
CREATE TABLE doctors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    doctor_name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    experience_years INT DEFAULT 0,
    status VARCHAR(20) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Doctor Availability slots
CREATE TABLE doctor_availability (
    id INT AUTO_INCREMENT PRIMARY KEY,
    doctor_id INT NOT NULL,
    available_date DATE NOT NULL,
    time_slot VARCHAR(50) NOT NULL,
    is_booked BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(id) ON DELETE CASCADE,
    UNIQUE KEY unique_doctor_slot (doctor_id, available_date, time_slot)
);

-- Appointments table
CREATE TABLE appointments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATE NOT NULL,
    time_slot VARCHAR(50) NOT NULL,
    status VARCHAR(20) DEFAULT 'scheduled',
    reason TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(id) ON DELETE CASCADE
);

-- Seed Default Admin Account
INSERT INTO admins (email, password, name) VALUES ('admin@healthcare.com', 'admin123', 'System Admin');

-- Seed Sample Doctors
INSERT INTO doctors (doctor_name, specialization, email, phone, experience_years, status) VALUES
('Dr. John Smith', 'Cardiology', 'john.smith@healthcare.com', '123-456-7890', 12, 'active'),
('Dr. Sarah Connor', 'Pediatrics', 'sarah.connor@healthcare.com', '123-456-7891', 8, 'active'),
('Dr. Alan Grant', 'Orthopedics', 'alan.grant@healthcare.com', '123-456-7892', 15, 'active'),
('Dr. Ellie Sattler', 'Dermatology', 'ellie.sattler@healthcare.com', '123-456-7893', 10, 'active');

-- Seed Doctor Availability slots
INSERT INTO doctor_availability (doctor_id, available_date, time_slot, is_booked) VALUES
(1, CURDATE(), '09:00 AM', FALSE),
(1, CURDATE(), '10:00 AM', FALSE),
(1, CURDATE(), '11:00 AM', FALSE),
(1, CURDATE() + INTERVAL 1 DAY, '02:00 PM', FALSE),
(1, CURDATE() + INTERVAL 1 DAY, '03:00 PM', FALSE),
(2, CURDATE(), '09:30 AM', FALSE),
(2, CURDATE(), '10:30 AM', FALSE),
(2, CURDATE() + INTERVAL 1 DAY, '11:30 AM', FALSE),
(2, CURDATE() + INTERVAL 1 DAY, '01:30 PM', FALSE),
(3, CURDATE() + INTERVAL 1 DAY, '09:00 AM', FALSE),
(3, CURDATE() + INTERVAL 1 DAY, '10:00 AM', FALSE),
(4, CURDATE() + INTERVAL 2 DAY, '10:00 AM', FALSE),
(4, CURDATE() + INTERVAL 2 DAY, '11:00 AM', FALSE),
(4, CURDATE() + INTERVAL 2 DAY, '02:00 PM', FALSE);
