require "db"
require "pg"

module Database
  extend self

  Connection = DB.open(database_connection)

  DB.open(database_connection) do |db|
    File.read("#{Path[__DIR__]}/create_tables.sql").split("\n").each { |sql| db.exec(sql) }
    puts "database created for '#{ENV.fetch("ENVIRONMENT")}'"

    unless ENV.fetch("ENVIRONMENT") == "prod"
      File.read("#{Path[__DIR__]}/seed.sql").split("\n").each { |sql| db.exec(sql) }
      puts "database seeded for '#{ENV.fetch("ENVIRONMENT")}'"
    end

    # refer to https://github.com/crystal-lang/crystal-db#usage for further information
  end

  def database_connection
    "postgres://#{ENV.fetch("PG_USER")}:#{ENV.fetch("PG_PASSWORD")}@#{ENV.fetch("PG_HOST")}:#{ENV.fetch("PG_PORT")}/#{ENV.fetch("PG_DB_NAME")}"
  end
end
