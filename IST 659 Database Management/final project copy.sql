SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if not exists (select * from sys.databases where name = 'project')
    create database project
go

use project
go

-- DOWN
if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_bills_bill_for_owner')
    alter table bills drop constraint fk_bills_bill_for_owner
if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_bills_bill_for_appointment')
    alter table bills drop constraint fk_bills_bill_for_appointment
drop table if exists bills
if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'appointment_assign_doctor')
    alter table appointments drop constraint appointment_assign_doctor
if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_appointments_appointment_by_owner')
    alter table appointments drop constraint fk_appointments_appointment_by_owner
if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_appointments_appointment_by_patient')
    alter table appointments drop constraint fk_appointments_appointment_by_patient
drop table if exists appointments
drop table if exists doctors
if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME = 'fk_patients_patient_owned_by')
    alter table patients drop constraint fk_patients_patient_owned_by
drop table if exists patients
drop table if exists owners

GO
-- UP Metadata
create table owners (
    owner_id int identity not null,
    owner_firstname VARCHAR(50) not null,
    owner_lastname VARCHAR(50) not null,
    owner_email VARCHAR(50) not null,
    owner_phone_number INT not null,
    owner_insurance VARCHAR(50) null --not sure
    constraint pk_owners_owner_id primary key (owner_id),
    constraint u_owners_owner_email unique (owner_email),
    constraint u_owners_owner_phone_number unique (owner_phone_number)
)
create table patients (
    patient_id int identity not null, 
    patient_name VARCHAR(50) not null,
    patient_date DATE not null,
    patient_species VARCHAR(50) not null,
    patient_type VARCHAR(50) not null,
    patient_owned_by int not null,
    constraint pk_patients_patient_id primary key (patient_id)
)
-- 1 foreign key 
alter table patients --who owned patients, patients are many side.
    add constraint fk_patients_patient_owned_by foreign key (patient_owned_by)
    references owners(owner_id) 
-- end
create table doctors (
    doctor_id int identity not null,
    doctor_firstname VARCHAR(50) not null,
    doctor_lastname VARCHAR(50) not null,
    doctor_email VARCHAR(50) not null,
    doctor_phone_number INT not null,
    doctor_schedule DATETIME not null,
    doctor_animal_treatable char(3) not null,
    constraint pk_doctors_doctor_id primary key (doctor_id),
    constraint u_doctors_doctor_email unique (doctor_email),
    constraint u_doctors_doctor_phone_number unique (doctor_phone_number)
)
create table appointments (
    appointment_id int identity not null,
    appointment_time time not null,
    appointment_date date not null, 
    appointment_reason varchar(300) not null,
    appointment_diagnosis VARCHAR(300) NULL,
    appointment_treatment CHAR(3) not null,
    appointment_by_patient int not null,
    appointment_by_owner int not null,
    appointment_assign_doctor int not null, 
    constraint pk_appointments_appointment_id primary key (appointment_id)
)
-- 3 foreign key
alter table appointments --the appointment for patient, appointments are many side.
    add constraint fk_appointments_appointment_by_patient foreign key (appointment_by_patient)
    references patients(patient_id)
alter table appointments --the appointment attended by owner, appointments are many side.
    add constraint fk_appointments_appointment_by_owner foreign key (appointment_by_owner)
    references owners(owner_id)
alter table appointments --the appointment assigned to doctor, appointments are many side.
    add constraint fk_appointments_appointment_assign_doctor foreign key (appointment_assign_doctor)
    references doctors(doctor_id)
-- end
create table bills (
    bill_id int identity not null,
    bill_treatment_cost int not null,
    bill_medication_cost int not null,
    bill_insurance_covering int NULL,
    bill_for_appointment int not null, 
    bill_for_owner int not null,
    constraint pk_bills_bill_id primary key (bill_id)
)
-- 2 foreign key
alter table bills --bill for which appointment, this is one to one.
    add constraint fk_bills_bill_for_appointment foreign key (bill_for_appointment)
    references appointments(appointment_id)
alter table bills --bill paid by owner, this is one to one.
    add constraint fk_bills_bill_for_owner foreign key (bill_for_owner)
    references owners(owner_id)
-- end
GO

-- UP Data

-- Verify