require "db"
require "pg"

DB.connect("postgres://postgres:postgres@localhost:5432/sports_deal_emailer_dev") do |db|
  # we have a user,
  # that has an contact method
  #   contact method (email text UNIQUE, frequency integer) # it might be a good idea to avoid frequency for now
  #     in the future we may want to support sms (mobile_number varchar[10] UNIQUE, frequency integer)
  # that has a region
  #   region has a zip code
  db.exec "create table if not exists emails (email text UNIQUE, frequency integer)"
  puts "database connection established"
  # db.exec "insert into emails values ($1)", "leozverres2@gmail.com"
  # refer to https://github.com/crystal-lang/crystal-db#usage for further information
end
