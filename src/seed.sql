do $$
declare
email_disabled_contact_method_id contact_method.id%type;
email_disabled_address_id address.id%type;
begin
insert into contact_method (contact_type, contact_detail) values ('email', 'poodude@gmail.com') returning id into email_disabled_contact_method_id;
insert into address (zipcode) values ('12345') returning id into email_disabled_address_id;
insert into users (contact_method_id, address_id) values (email_disabled_contact_method_id, email_disabled_address_id);
end;
$$;
insert into contact_method (contact_type, contact_detail, enabled) values ('email', 'poogalentity@gmail.com', true);
insert into contact_method (contact_type, contact_detail) values ('phone_number', '1234567890');
insert into contact_method (contact_type, contact_detail, enabled) values ('phone_number', '0987654321', true);
