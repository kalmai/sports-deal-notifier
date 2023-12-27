require "db"
require "pg"

module Database
  extend self

  Connection = DB.open(database_connection)

  DB.open(database_connection) do |db|
    # TODO: migrate this block of code to reading from a seed file of some kind?
    # we have a user,
    # that has an contact method
    #   contact method (email text UNIQUE, frequency integer) # it might be a good idea to avoid frequency for now
    #     in the future we may want to support sms (mobile_number varchar[10] UNIQUE, frequency integer)
    #       in all of these instances we want to return a success from our server to mask data we already have
    # that has a region
    #   region has a zip code
    # i want to use email for now to collect user contact info and then we can save the the zipcode
    # they give us and lookup via this handy api
    # db.exec "create table if not exists zip_code_teams"
    # we should have a table with all the teams maybe at some point versus

    db.exec "drop table emails"
    db.exec "create table if not exists emails (email text UNIQUE, email_enabled boolean default false)"
    db.exec "drop table phone_numbers"
    db.exec "create table if not exists phone_numbers (phone_number varchar(16) UNIQUE, phone_number_enabled boolean default false)"

    db.exec "insert into emails values ($1)", "poodude@gmail.com"
    db.exec "insert into emails values ($1, $2)", "poogalentity@gmail.com", true
    db.exec "insert into phone_numbers values ($1)", "1234567890"
    db.exec "insert into phone_numbers values ($1, $2)", "0987654321", true

    puts "database created for '#{ENV.fetch("ENVIRONMENT")}'"
    # refer to https://github.com/crystal-lang/crystal-db#usage for further information
  end

  def database_connection
    "postgres://#{ENV.fetch("PG_USER")}:#{ENV.fetch("PG_PASSWORD")}@#{ENV.fetch("PG_HOST")}:#{ENV.fetch("PG_PORT")}/#{ENV.fetch("PG_DB_NAME")}"
  end
end
