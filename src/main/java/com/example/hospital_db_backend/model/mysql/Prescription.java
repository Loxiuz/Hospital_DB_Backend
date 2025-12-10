package com.example.hospital_db_backend.model.mysql;

import com.example.hospital_db_backend.model.entity_bases.PrescriptionBase;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.UUID;

@Getter
@Setter
@Entity
@Table(name = "prescriptions", indexes = {
    @Index(name = "idx_prescription_start_date", columnList = "startDate"),
    @Index(name = "idx_prescription_patient", columnList = "patient_id"),
    @Index(name = "idx_prescription_patient_dates", columnList = "patient_id,startDate,endDate")
})
public class Prescription extends PrescriptionBase {
    @Id
    private UUID prescriptionId;
    
    @ManyToOne
    @JoinColumn(nullable = false)
    private Patient patient;
    
    @ManyToOne
    @JoinColumn(nullable = false)
    private Doctor doctor;
    
    @ManyToOne
    @JoinColumn(nullable = false)
    private Medication medication;
}
