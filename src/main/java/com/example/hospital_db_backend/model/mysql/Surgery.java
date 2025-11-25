package com.example.hospital_db_backend.model.mysql;

import com.example.hospital_db_backend.model.entity_bases.SurgeryBase;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.UUID;

@Getter
@Setter
@Entity
@Table(name = "surgeries", indexes = {
    @Index(name = "idx_surgery_date", columnList = "surgeryDate"),
    @Index(name = "idx_surgery_patient_date", columnList = "patient_id,surgeryDate"),
    @Index(name = "idx_surgery_doctor_date", columnList = "doctor_id,surgeryDate")
})
public class Surgery extends SurgeryBase {
    @Id
    private UUID surgeryId;
    
    @ManyToOne
    @JoinColumn(nullable = false)
    private Patient patient;
    
    @ManyToOne
    @JoinColumn(nullable = false)
    private Doctor doctor;
}
