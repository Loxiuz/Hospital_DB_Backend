drop procedure if exists patients_in_ward;
create procedure patients_in_ward (in w_id int)
begin
    select p.patient_id, p.patient_name, p.date_of_birth, w.ward_name, h.hospital_name
    from patients p
             join wards w on p.ward_id = w.ward_id
             join hospitals h on p.hospital_id = h.hospital_id
    where w.ward_id = w_id;
end;

drop procedure if exists get_patient_medical_history;
delimiter //
create procedure get_patient_medical_history(in p_id int)
begin
    select 
        p.patient_id,
        p.patient_name,
        p.date_of_birth,
        timestampdiff(year, p.date_of_birth, curdate()) as age,
        p.gender,
        w.ward_name,
        h.hospital_name,
        h.address as hospital_address,
        h.city as hospital_city
    from patients p
    join wards w on p.ward_id = w.ward_id
    join hospitals h on p.hospital_id = h.hospital_id
    where p.patient_id = p_id;
    
    -- Diagnoses
    select 
        d.diagnosis_id,
        d.diagnosis_date,
        d.description,
        doc.doctor_name,
        doc.specialty as doctor_specialty
    from diagnosis d
    join doctors doc on d.doctor_id = doc.doctor_id
    where d.patient_id = p_id
    order by d.diagnosis_date desc;
    
    -- Surgeries
    select 
        s.surgery_id,
        s.surgery_date,
        s.description,
        doc.doctor_name,
        doc.specialty as doctor_specialty
    from surgeries s
    join doctors doc on s.doctor_id = doc.doctor_id
    where s.patient_id = p_id
    order by s.surgery_date desc;
    
    -- Prescriptions (Active and Historical)
    select 
        pr.prescription_id,
        m.medication_name,
        m.dosage,
        pr.start_date,
        pr.end_date,
        doc.doctor_name,
        doc.specialty as doctor_specialty,
        case 
            when pr.end_date is null or pr.end_date >= curdate() then 'Active'
            else 'Expired'
        end as status
    from prescriptions pr
    join medications m on pr.medication_id = m.medication_id
    join doctors doc on pr.doctor_id = doc.doctor_id
    where pr.patient_id = p_id
    order by pr.start_date desc;
    
    -- Appointments (All History)
    select 
        a.appointment_id,
        a.appointment_date,
        a.reason,
        a.status,
        doc.doctor_name as doctor_name,
        doc.specialty as doctor_specialty,
        n.nurse_name,
        n.specialty as nurse_specialty
    from appointments a
    left join doctors doc on a.doctor_id = doc.doctor_id
    left join nurses n on a.nurse_id = n.nurse_id
    where a.patient_id = p_id
    order by a.appointment_date desc;
end //
delimiter ;

call patients_in_ward(1);