package com.example.hospital_db_backend.model.mysql;

import com.example.hospital_db_backend.model.entity_bases.MedicationBase;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import lombok.Getter;
import lombok.Setter;

import java.util.UUID;

@Getter
@Setter
@Entity
@Table(name = "medications", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"medicationName", "dosage"})
})
public class Medication extends MedicationBase {
    @Id
    private UUID medicationId;
}
