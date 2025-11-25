package com.example.hospital_db_backend.model.mysql;

import com.example.hospital_db_backend.model.entity_bases.AppointmentBase;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.UUID;

@Getter
@Setter
@Entity
@Table(name = "appointments", indexes = {
    @Index(name = "idx_appointment_date", columnList = "appointmentDate"),
    @Index(name = "idx_appointment_status", columnList = "status"),
    @Index(name = "idx_appointment_patient_date", columnList = "patient_id,appointmentDate"),
    @Index(name = "idx_appointment_doctor_date", columnList = "doctor_id,appointmentDate")
})
public class Appointment extends AppointmentBase {
    @Id
    private UUID appointmentId;
    
    @ManyToOne
    @JoinColumn(nullable = false)
    private Patient patient;
    
    @ManyToOne
    private Doctor doctor;
    
    @ManyToOne
    private Nurse nurse;
}
