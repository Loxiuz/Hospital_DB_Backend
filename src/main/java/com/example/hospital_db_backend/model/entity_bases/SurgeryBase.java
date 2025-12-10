package com.example.hospital_db_backend.model.entity_bases;

import jakarta.persistence.Column;
import jakarta.persistence.MappedSuperclass;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;

@Getter
@Setter
@MappedSuperclass
public abstract class SurgeryBase {
    @Column(nullable = false)
    protected LocalDate surgeryDate;
    
    @Column(nullable = false)
    protected String description;
}
