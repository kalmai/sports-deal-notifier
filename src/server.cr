require "./initializer"
require "http/server"
require "./controller"

module Sports::Deal::Emailer
  VERSION = "0.1.0"
  include Controller

  server = HTTP::Server.new do |context|
    Controller.parse_request(context)
  end

  address = server.bind_tcp 8080
  puts "listening on http:://#{address}"
  server.listen
end
