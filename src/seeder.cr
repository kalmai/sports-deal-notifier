module Seeder
  extend self

  def create_database
    DB.connect(Database.database_connection) do |conn|
      conn.exec("drop table if exists contact_method cascade")
      conn.exec("create table if not exists contact_method (id serial primary key, contact_type varchar(20), contact_detail varchar(100) UNIQUE, enabled boolean default false)")
      conn.exec("drop table if exists address cascade")
      conn.exec("create table if not exists address (id serial primary key, zipcode varchar(15) UNIQUE)")
      conn.exec("drop table if exists users cascade")
      conn.exec("create table if not exists users (id serial primary key, contact_method_id integer, address_id integer, constraint fk_contact_method foreign key(contact_method_id) references contact_method(id), constraint fk_address_users foreign key(address_id) references address(id))")
      conn.exec("drop table if exists promotion cascade")
      conn.exec("create table if not exists promotion(id serial primary key, name varchar(50), url varchar(255), slug varchar(100))")
      conn.exec("drop table if exists team cascade")
      conn.exec("create table if not exists team (id serial primary key, short_name varchar(5) UNIQUE, long_name varchar(30), address_id integer, promotion_id integer, league varchar(5), constraint fk_address_team foreign key(address_id) references address(id), constraint fk_promotion foreign key(promotion_id) references promotion(id))")
    end
  end

  def seed_local_env
    create_user_address_contact_method("email", "poodude@gmail.com", "22345", false)
    create_user_address_contact_method("email", "hello@world.com", "12345", true)
    create_user_address_contact_method("phone_number", "1234567890", "32345", false)
    create_user_address_contact_method("phone_number", "0987654321", "42345", true)
  end

  def create_user_address_contact_method(type : String, detail : String, zipcode : String, enabled : Bool)
    Database::Connection.exec(
    <<-SQL
      do $$
      declare
      email_disabled_contact_method_id contact_method.id%type;
      email_disabled_address_id address.id%type;
      begin
      insert into contact_method (contact_type, contact_detail, enabled) values ('#{type}', '#{detail}', '#{enabled}') returning id into email_disabled_contact_method_id;
      insert into address (zipcode) values ('#{zipcode}') returning id into email_disabled_address_id;
      insert into users (contact_method_id, address_id) values (email_disabled_contact_method_id, email_disabled_address_id);
      end;
      $$;
    SQL
    )
  end
end
