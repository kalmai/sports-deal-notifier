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
    when "/register_phone_number"
      return register_phone_number(context)
    end
  end

  def register_email(context)
    request_hash = request_hash(context)
    Database::Connection.exec("insert into emails (email) values ($1)", request_hash["email"])
  end

  def register_phone_number(context)
    request_hash = request_hash(context)
    Database::Connection.exec("insert into phone_numbers (phone_number) values ($1)", request_hash["phone_number"])
  end

  def root(context)
    filename = "./src/view.html"
    context.response.content_type = "text/html"
    context.response.content_length = File.size(filename)
    File.open(filename) do |file|
      IO.copy(file, context.response)
    end
  end

  def request_hash(context) : Hash
    body = context.request.body.try(&.gets_to_end)
    Hash(String, String).from_json(body.to_s)
  end
end
