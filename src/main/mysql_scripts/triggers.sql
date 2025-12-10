drop trigger if exists adding_patient_to_full_ward;
delimiter //
create trigger adding_patient_to_full_ward
    before insert on patients
    for each row
begin
    declare ward_capacity int;
    declare current_patient_count int;
    declare ward_name varchar(50);

    select max_capacity into ward_capacity
    from wards
    where ward_id = new.ward_id;

    select count(*) into current_patient_count
    from patients
    where ward_id = new.ward_id;

    select ward_name into ward_name
    from wards
    where ward_id = new.ward_id;

    if current_patient_count >= ward_capacity then
        signal sqlstate '45000'
            set message_text = 'Cannot add patient to ward capacity full';
    end if;
end //

drop table if exists audit_log;
create table audit_log (
    audit_id int primary key auto_increment,
    table_name varchar(50) not null,
    operation_type enum('INSERT', 'UPDATE', 'DELETE') not null,
    record_id int not null,
    old_values json,
    new_values json,
    changed_by varchar(100),
    change_timestamp datetime default current_timestamp,
    ip_address varchar(45)
);

drop trigger if exists audit_patient_insert;
delimiter //
create trigger audit_patient_insert
    after insert on patients
    for each row
begin
    insert into audit_log (
        table_name,
        operation_type,
        record_id,
        new_values,
        change_timestamp
    ) values (
        'patients',
        'INSERT',
        new.patient_id,
        json_object(
            'patient_id', new.patient_id,
            'patient_name', new.patient_name,
            'date_of_birth', new.date_of_birth,
            'ward_id', new.ward_id,
            'hospital_id', new.hospital_id,
            'gender', new.gender
        ),
        now()
    );
end //

drop trigger if exists audit_patient_update;
delimiter //
create trigger audit_patient_update
    after update on patients
    for each row
begin
    insert into audit_log (
        table_name,
        operation_type,
        record_id,
        old_values,
        new_values,
        change_timestamp
    ) values (
        'patients',
        'UPDATE',
        new.patient_id,
        json_object(
            'patient_id', old.patient_id,
            'patient_name', old.patient_name,
            'date_of_birth', old.date_of_birth,
            'ward_id', old.ward_id,
            'hospital_id', old.hospital_id,
            'gender', old.gender
        ),
        json_object(
            'patient_id', new.patient_id,
            'patient_name', new.patient_name,
            'date_of_birth', new.date_of_birth,
            'ward_id', new.ward_id,
            'hospital_id', new.hospital_id,
            'gender', new.gender
        ),
        now()
    );
end //

drop trigger if exists audit_patient_delete;
delimiter //
create trigger audit_patient_delete
    after delete on patients
    for each row
begin
    insert into audit_log (
        table_name,
        operation_type,
        record_id,
        old_values,
        change_timestamp
    ) values (
        'patients',
        'DELETE',
        old.patient_id,
        json_object(
            'patient_id', old.patient_id,
            'patient_name', old.patient_name,
            'date_of_birth', old.date_of_birth,
            'ward_id', old.ward_id,
            'hospital_id', old.hospital_id,
            'gender', old.gender
        ),
        now()
    );
end //
delimiter ;