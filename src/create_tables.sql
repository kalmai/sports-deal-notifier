drop table if exists contact_method cascade;
create table if not exists contact_method (id serial primary key, contact_type varchar(20), contact_detail varchar(100) UNIQUE, enabled boolean default false);
drop table if exists address cascade;
create table if not exists address (id serial primary key, zipcode varchar(15));
drop table if exists users cascade;
create table if not exists users (id serial primary key, contact_method_id integer, address_id integer, constraint fk_contact_method foreign key(contact_method_id) references contact_method(id), constraint fk_address_users foreign key(address_id) references address(id));

drop table if exists promotion cascade;
create table if not exists promotion(id serial primary key, name varchar(50), url varchar(255), slug varchar(100));

drop table if exists team cascade;
create table if not exists team (id serial primary key, short_name varchar(5) UNIQUE, long_name varchar(30), address_id integer, promotion_id integer, league varchar(5), constraint fk_address_team foreign key(address_id) references address(id), constraint fk_promotion foreign key(promotion_id) references promotion(id));

