require "http/server"
require "./database"

module Sports::Deal::Emailer
  VERSION = "0.1.0"


  rs = db.query "select * from emails"
  server = HTTP::Server.new do |context|
    context.response.content_type = "text/plain"
    context.response.print "hi marc"
    context.response.print "#{rs.first.read(String)}"
  end

  address = server.bind_tcp 8080
  puts "listening on http:://#{address}"
  server.listen
end
