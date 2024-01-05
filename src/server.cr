require "./initializer"
require "http/server"
require "./controller"
require "http/server/handler"

module Sports::Deal::Notifier
  VERSION = "0.1.0"
  include Controller

  server = HTTP::Server.new([CustomHandler.new]) do |context|
    Controller.parse_request(context)
  end

  address = server.bind_tcp 8080
  puts "listening on http:://#{address}"
  server.listen
end


class CustomHandler
  include HTTP::Handler

  def call(context)
    context.response.headers["Access-Control-Allow-Headers"] = "Content-Type"
    context.response.headers["Access-Control-Allow-Origin"] = "*"
    puts "Doing some stuff"
    call_next(context)
  end
end
