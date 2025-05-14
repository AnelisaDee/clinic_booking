-- ========================================================
-- DATABASE: Clinic Booking System
-- DESCRIPTION: Manages patients, doctors, appointments,
--              treatments, prescriptions, and specializations.
-- AUTHOR: [Your Name]
-- DATE: [Today’s Date]
-- ========================================================

-- Step 1: Create the database
CREATE DATABASE IF NOT EXISTS clinic_booking;
USE clinic_booking;

-- Step 2: Drop existing tables (for safe re-runs)
DROP TABLE IF EXISTS Prescriptions;
DROP TABLE IF EXISTS Treatments;
DROP TABLE IF EXISTS Appointments;
DROP TABLE IF EXISTS DoctorSpecializations;
DROP TABLE IF EXISTS Specializations;
DROP TABLE IF EXISTS Doctors;
DROP TABLE IF EXISTS Patients;

-- ========================================================
-- TABLE: Patients
-- DESCRIPTION: Stores patient information.
-- ========================================================
CREATE TABLE Patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,           -- Unique ID for each patient
    first_name VARCHAR(50) NOT NULL,                     -- Patient's first name
    last_name VARCHAR(50) NOT NULL,                      -- Patient's last name
    date_of_birth DATE NOT NULL,                         -- Date of birth
    gender ENUM('Male', 'Female', 'Other') NOT NULL,     -- Gender identity
    phone VARCHAR(15) UNIQUE NOT NULL,                   -- Contact number (unique)
    email VARCHAR(100) UNIQUE NOT NULL                   -- Email address (unique)
);

-- ========================================================
-- TABLE: Doctors
-- DESCRIPTION: Stores doctor information.
-- ========================================================
CREATE TABLE Doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,            -- Unique ID for each doctor
    first_name VARCHAR(50) NOT NULL,                     -- Doctor's first name
    last_name VARCHAR(50) NOT NULL,                      -- Doctor's last name
    phone VARCHAR(15) UNIQUE NOT NULL,                   -- Contact number (unique)
    email VARCHAR(100) UNIQUE NOT NULL                   -- Email address (unique)
);

-- ========================================================
-- TABLE: Specializations
-- DESCRIPTION: Stores medical specializations (e.g., cardiology, dermatology).
-- ========================================================
CREATE TABLE Specializations (
    specialization_id INT AUTO_INCREMENT PRIMARY KEY,    -- Unique specialization ID
    name VARCHAR(100) UNIQUE NOT NULL                    -- Name of the specialization
);

-- ========================================================
-- TABLE: DoctorSpecializations
-- DESCRIPTION: Many-to-Many relationship between doctors and specializations.
-- ========================================================
CREATE TABLE DoctorSpecializations (
    doctor_id INT NOT NULL,                              -- Foreign key to Doctors
    specialization_id INT NOT NULL,                      -- Foreign key to Specializations
    PRIMARY KEY (doctor_id, specialization_id),          -- Composite PK
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id) ON DELETE CASCADE,
    FOREIGN KEY (specialization_id) REFERENCES Specializations(specialization_id) ON DELETE CASCADE
);

-- ========================================================
-- TABLE: Appointments
-- DESCRIPTION: Stores appointment details between patients and doctors.
-- ========================================================
CREATE TABLE Appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,       -- Unique appointment ID
    patient_id INT NOT NULL,                             -- FK to Patients
    doctor_id INT NOT NULL,                              -- FK to Doctors
    appointment_date DATETIME NOT NULL,                  -- Scheduled date and time
    reason TEXT,                                          -- Reason for the visit
    status ENUM('Scheduled', 'Completed', 'Cancelled') DEFAULT 'Scheduled', -- Appointment status
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

-- ========================================================
-- TABLE: Treatments
-- DESCRIPTION: Each appointment can have one treatment record.
-- ========================================================
CREATE TABLE Treatments (
    treatment_id INT AUTO_INCREMENT PRIMARY KEY,         -- Unique treatment ID
    appointment_id INT UNIQUE NOT NULL,                  -- FK to Appointments (1:1)
    description TEXT NOT NULL,                           -- Description of the treatment
    notes TEXT,                                           -- Optional notes
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id) ON DELETE CASCADE
);

-- ========================================================
-- TABLE: Prescriptions
-- DESCRIPTION: Stores multiple prescriptions per appointment.
-- ========================================================
CREATE TABLE Prescriptions (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,      -- Unique prescription ID
    appointment_id INT NOT NULL,                         -- FK to Appointments (1:M)
    medication_name VARCHAR(100) NOT NULL,               -- Medication prescribed
    dosage VARCHAR(50) NOT NULL,                         -- Dosage details
    instructions TEXT NOT NULL,                          -- How the medication should be taken
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id) ON DELETE CASCADE
);
