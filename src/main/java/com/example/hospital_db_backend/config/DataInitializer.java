package com.example.hospital_db_backend.config;

import com.example.hospital_db_backend.model.mysql.Hospital;
import com.example.hospital_db_backend.model.mysql.User;
import com.example.hospital_db_backend.model.mysql.Ward;
import com.example.hospital_db_backend.model.types.Role;
import com.example.hospital_db_backend.model.types.WardType;
import com.example.hospital_db_backend.repository.HospitalRepository;
import com.example.hospital_db_backend.repository.UserRepository;
import com.example.hospital_db_backend.repository.WardRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

@Component
public class DataInitializer implements CommandLineRunner {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final HospitalRepository hospitalRepository;
    private final WardRepository wardRepository;

    public DataInitializer(UserRepository userRepository, PasswordEncoder passwordEncoder,
                          HospitalRepository hospitalRepository, WardRepository wardRepository) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.hospitalRepository = hospitalRepository;
        this.wardRepository = wardRepository;
    }

    @Override
    public void run(String... args) {
        // Initialize admin user
        if (userRepository.findByUsername("admin").isEmpty()) {
            User admin = new User();
            admin.setUserId(UUID.randomUUID());
            admin.setUsername("admin");
            admin.setPassword(passwordEncoder.encode("admin"));
            admin.setRole(Role.ADMIN);
            userRepository.save(admin);
        }

        // Initialize hospitals if they don't exist
        if (hospitalRepository.count() == 0) {
            // Create Rigshospitalet
            Hospital rigshospitalet = new Hospital();
            rigshospitalet.setHospitalId(UUID.randomUUID());
            rigshospitalet.setHospitalName("Rigshospitalet");
            rigshospitalet.setAddress("Blegdamsvej 9");
            rigshospitalet.setCity("København");
            rigshospitalet = hospitalRepository.save(rigshospitalet);

            // Create Aarhus Universitetshospital
            Hospital aarhusHospital = new Hospital();
            aarhusHospital.setHospitalId(UUID.randomUUID());
            aarhusHospital.setHospitalName("Aarhus Universitetshospital");
            aarhusHospital.setAddress("Palle Juul-Jensens Boulevard 99");
            aarhusHospital.setCity("Aarhus");
            aarhusHospital = hospitalRepository.save(aarhusHospital);

            // Initialize wards if they don't exist
            if (wardRepository.count() == 0) {
                // Kardiologi Afdeling (associated with Rigshospitalet)
                Ward kardiologiWard = new Ward();
                kardiologiWard.setWardId(UUID.randomUUID());
                kardiologiWard.setType(WardType.CARDIOLOGY);
                kardiologiWard.setMaxCapacity(30);
                Set<Hospital> kardiologiHospitals = new HashSet<>();
                kardiologiHospitals.add(rigshospitalet);
                kardiologiWard.setHospitals(kardiologiHospitals);
                wardRepository.save(kardiologiWard);

                // Neurologi Afdeling (associated with Rigshospitalet)
                Ward neurologiWard = new Ward();
                neurologiWard.setWardId(UUID.randomUUID());
                neurologiWard.setType(WardType.NEUROLOGY);
                neurologiWard.setMaxCapacity(25);
                Set<Hospital> neurologiHospitals = new HashSet<>();
                neurologiHospitals.add(rigshospitalet);
                neurologiWard.setHospitals(neurologiHospitals);
                wardRepository.save(neurologiWard);

                // Almen Medicin Afdeling (associated with Aarhus Universitetshospital)
                Ward almenMedicinWard = new Ward();
                almenMedicinWard.setWardId(UUID.randomUUID());
                almenMedicinWard.setType(WardType.GENERAL_MEDICINE);
                almenMedicinWard.setMaxCapacity(20);
                Set<Hospital> almenMedicinHospitals = new HashSet<>();
                almenMedicinHospitals.add(aarhusHospital);
                almenMedicinWard.setHospitals(almenMedicinHospitals);
                wardRepository.save(almenMedicinWard);
            }
        }
    }
}

