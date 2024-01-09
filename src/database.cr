require "db"
require "pg"
require "./seeder"

module Database
  extend self

  include Seeder

  Connection = DB.open(database_connection)

  DB.open(database_connection) do |db|
    Seeder.create_database
    puts "database created for '#{ENV.fetch("ENVIRONMENT")}'"

    unless ENV.fetch("ENVIRONMENT") == "prod"
      Seeder.seed_local_env
      puts "database seeded for '#{ENV.fetch("ENVIRONMENT")}'"
    end

    # refer to https://github.com/crystal-lang/crystal-db#usage for further information
  end

  def database_connection
    "postgres://#{ENV.fetch("PG_USER")}:#{ENV.fetch("PG_PASSWORD")}@#{ENV.fetch("PG_HOST")}:#{ENV.fetch("PG_PORT")}/#{ENV.fetch("PG_DB_NAME")}"
  end
end
