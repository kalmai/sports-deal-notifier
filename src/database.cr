require "db"
require "pg"

module Database
  extend self

  DATABASE_CONNECTION = database_connection

  DB.open(DATABASE_CONNECTION) do |db|
    # we have a user,
    # that has an contact method
    #   contact method (email text UNIQUE, frequency integer) # it might be a good idea to avoid frequency for now
    #     in the future we may want to support sms (mobile_number varchar[10] UNIQUE, frequency integer)
    #       in all of these instances we want to return a success from our server to mask data we already have
    # that has a region
    #   region has a zip code
    # i want to use email for now to collect user contact info and then we can save the the zipcode
    # they give us and lookup via this handy api
    db.exec "drop table emails"
    db.exec "create table if not exists emails (email text UNIQUE, frequency integer)"
    # db.exec "create table if not exists zip_code_teams"
    # we should have a table with all the teams maybe at some point versus
    puts "database created for '#{ENV.fetch("ENVIRONMENT")}'"
    # db.exec "insert into emails values ($1)", "leozverres2@gmail.com"
    # refer to https://github.com/crystal-lang/crystal-db#usage for further information
  end

  def execute(**args)
    DB.open(DATABASE_CONNECTION) do |db|
      db.transaction do |tx|
        cnn = tx.connection
        cnn.exec(args[:query], *args[:params])
      end
    end
  end

  # if there are no positional args for your prepared sql query, you need
  # to call `Tuple.new` in order to instantiate an empty Tuple to be able to call
  # the below method
  def query(**args)
    DB.open(DATABASE_CONNECTION) do |db|
      args[:args] ? db.query(args[:query], *args[:params]) : db.query(args[:query])
    end
  end

  def database_connection
    "postgres://#{ENV.fetch("PG_USER")}:#{ENV.fetch("PG_PASSWORD")}@#{ENV.fetch("PG_HOST")}:#{ENV.fetch("PG_PORT")}/#{ENV.fetch("PG_DB_NAME")}"
  end
end
