create or replace view scheduled_appointments as
select a.appointment_id,
       p.patient_name,
       d.doctor_name,
       n.nurse_name,
       a.appointment_date,
       a.status
from appointments a
         join patients p on a.patient_id = p.patient_id
         join doctors d on a.doctor_id = d.doctor_id
         join nurses n on a.nurse_id = n.nurse_id
where a.appointment_date >= curdate()
  and a.status = 'Scheduled';

-- Ward Occupancy View
create or replace view ward_occupancy as
select 
    w.ward_id,
    w.ward_name,
    h.hospital_name,
    h.city,
    w.max_capacity,
    count(p.patient_id) as current_patients,
    w.max_capacity - count(p.patient_id) as available_beds,
    round((count(p.patient_id) / w.max_capacity) * 100, 2) as occupancy_percentage,
    case 
        when count(p.patient_id) >= w.max_capacity then 'Full'
        when count(p.patient_id) >= w.max_capacity * 0.8 then 'Near Capacity'
        else 'Available'
    end as status
from wards w
left join patients p on w.ward_id = p.ward_id
join hospitals h on w.hospital_id = h.hospital_id
group by w.ward_id, w.ward_name, h.hospital_name, h.city, w.max_capacity;

SELECT * FROM scheduled_appointments;