package com.example.hospital_db_backend.model.entity_bases;

import jakarta.persistence.Column;
import jakarta.persistence.MappedSuperclass;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@MappedSuperclass
public abstract class HospitalBase {
    @Column(nullable = false)
    protected String hospitalName;
    
    @Column(nullable = false)
    protected String address;
    
    @Column(nullable = false)
    protected String city;
}
