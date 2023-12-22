require "json"
require "./controller"
require "./database"

module Controller
  extend self

  def parse_request(context)
    routed_action(context)
  end

  def routed_action(context)
    case context.request.resource
    when "/"
      return root(context)
    when "/register_email"
      return register_email(context)
    end
  end

  def register_email(context)
    body = context.request.body.try(&.gets_to_end)
    request_hash = Hash(String, String).from_json(body.to_s)
    Database.execute(
      query: "insert into emails (email, frequency) values ($1, $2)",
      params: { request_hash["email"], 0 }
    )
  end

  def root(context)
    filename = "./src/view.html"
    context.response.content_type = "text/html"
    context.response.content_length = File.size(filename)
    File.open(filename) do |file|
      IO.copy(file, context.response)
    end
  end
end
