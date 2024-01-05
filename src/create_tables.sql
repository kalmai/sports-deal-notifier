drop table if exists emails;
create table if not exists emails (email_id serial primary key,email text UNIQUE, email_enabled boolean default false);
drop table if exists phone_numbers;
create table if not exists phone_numbers (phone_number varchar(16) UNIQUE, phone_number_enabled boolean default false);
