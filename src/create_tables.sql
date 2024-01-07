drop table if exists users;
create table if not exists users (
    id serial primary key,
    contact_method_id integer,
    address_id integer,
    constraint fk_contact_method foreign key(contact_method_id) references contact_method(id),
    constraint fk_address_users foreign key(address_id) references address(id)
);
drop table if exists contact_method;
create table if not exists contact_method (
    id serial primary key,
    contact_type varchar[10],
    contact_detail varchar[20] UNIQUE,
    enabled boolean default false
);
-- addresses have zipcodes
drop table if exists address;
create table if not exists address (
    id serial primary key,
    zipcode varchar[15]
);

-- leagues have teams 
drop table if exists league;
create table if not exists league (
    id serial primary key,
    name varchar[5] UNIQUE,
    team_id integer,
    constraint fk_team foreign key(team_id) references team(id)
);

--  teams have short_name, long_name, zipcode_ids, promotions
drop table if exists team;
create table if not exists team (
    id serial primary key,
    short_name varchar[5] UNIQUE,
    long_name varchar[30],
    address_id integer,
    promotion_id integer,
    constraint fk_address_team foreign key(address_id) references address(id),
    constraint fk_promotion foreign key(promotion_id) references promotion(id)
);
drop table if exists promotion;
--   promotions have name, condition, url
-- seems like storing conditions in the database is a bad idea,
-- should probably just use a yml file
create table if not exists promotion(
    id serial primary key,
    name varchar[50],
    url varchar[255],
    slug varchar[100]
);
