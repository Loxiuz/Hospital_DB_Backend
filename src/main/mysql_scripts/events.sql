drop event if exists remove_old_cancelled_appointments;
create event remove_old_cancelled_appointments
    on schedule every 1 day
    starts '2025-10-01 00:00:00'
    do
        delete from appointments
        where status = 'Cancelled' and appointment_date < NOW() - INTERVAL 30 DAY;

-- Daily Statistics Report Event
drop event if exists generate_daily_statistics;
create event generate_daily_statistics
    on schedule every 1 day
    starts '2025-10-01 23:59:00'
    do
    begin
        -- Create daily statistics table if it doesn't exist
        create table if not exists daily_statistics (
            stat_date date primary key,
            total_patients int,
            total_appointments int,
            scheduled_appointments int,
            completed_appointments int,
            cancelled_appointments int,
            total_surgeries int,
            active_prescriptions int,
            total_diagnoses int,
            ward_utilization_avg decimal(5,2),
            created_at datetime default current_timestamp
        );
        
        -- Insert or update daily statistics
        insert into daily_statistics (
            stat_date,
            total_patients,
            total_appointments,
            scheduled_appointments,
            completed_appointments,
            cancelled_appointments,
            total_surgeries,
            active_prescriptions,
            total_diagnoses,
            ward_utilization_avg
        )
        select 
            curdate(),
            (select count(*) from patients),
            (select count(*) from appointments where date(appointment_date) = curdate()),
            (select count(*) from appointments 
             where date(appointment_date) = curdate() and status = 'Scheduled'),
            (select count(*) from appointments 
             where date(appointment_date) = curdate() and status = 'Completed'),
            (select count(*) from appointments 
             where date(appointment_date) = curdate() and status = 'Cancelled'),
            (select count(*) from surgeries where date(surgery_date) = curdate()),
            (select count(*) from prescriptions 
             where end_date is null or end_date >= curdate()),
            (select count(*) from diagnosis where date(diagnosis_date) = curdate()),
            (select avg(ward_occupancy_percentage(ward_id)) from wards)
        on duplicate key update
            total_patients = values(total_patients),
            total_appointments = values(total_appointments),
            scheduled_appointments = values(scheduled_appointments),
            completed_appointments = values(completed_appointments),
            cancelled_appointments = values(cancelled_appointments),
            total_surgeries = values(total_surgeries),
            active_prescriptions = values(active_prescriptions),
            total_diagnoses = values(total_diagnoses),
            ward_utilization_avg = values(ward_utilization_avg),
            created_at = current_timestamp;
    end;