drop function if exists patient_age;
create function patient_age (p_id int) returns int
    deterministic
begin
    declare age int;
    select timestampdiff(year, date_of_birth, curdate()) into age
    from patients
    where patient_id = p_id;
    return age;
end;

-- Ward Occupancy Percentage Function
drop function if exists ward_occupancy_percentage;
delimiter //
create function ward_occupancy_percentage(w_id int) returns decimal(5,2)
deterministic
reads sql data
begin
    declare capacity int;
    declare current_count int;
    declare occupancy decimal(5,2);
    
    select max_capacity into capacity
    from wards
    where ward_id = w_id;
    
    select count(*) into current_count
    from patients
    where ward_id = w_id;
    
    if capacity = 0 or capacity is null then
        return 0.00;
    end if;
    
    set occupancy = (current_count / capacity) * 100;
    return occupancy;
end //
delimiter ;

select patient_name, patient_age(patient_id) as age from patients;