require "json"

module Controller
  extend self

  def parse_request(context)
    routed_action(context)
  end

  def routed_action(context)
    case context.request.resource
    when "/"
      return root(context)
    when "/health"
      return health(context)
    when "/register"
      return register(context)
    end
  end

  # ## should probably break out the registration stuff to its own class or something...
  # should probably collapse these methods into one and add a checkbox on the FE to allow them to choose one/both?
  def register(context)
    request_hash = request_hash(context)
    contacts = JSON.parse request_hash.to_s
    zipcode_id = find_zipcode_id(contacts["zipcode"].as_s) # we will use this for the user eventually
    new_contact_methods = Array(NewContactMethod).from_json contacts["contact_methods"].to_json
    new_contact_methods.each do |method|
      Database::Connection.exec("insert into contact_method (contact_type, contact_detail, enabled) values ($1, $2, $3)", method.contact_type, method.contact_details, method.enabled)
    end
    debugger
    # record(NewContactMethod, t : String, detail : String, enabled : Bool)
    #  aas = Array(NewContactMethod).from_json(request_hash.to_s)
    # JobRunner.notify_of_deals
  end

  def find_zipcode_id(zip : String)
    # need to save data to our zipcode table in the future and check with db.query later
    # dont execute below if db.result otherwise crawl ballysport for the teams
    zip_id = nil
    rs = Database::Connection.query("select id, zipcode from address where zipcode = ($1)", zip)
    rs.each do
      p! zip_id = rs.read(Int)
    end

    return zip_id if zip_id

    zip_id = Database::Connection.exec("insert into address (zipcode) values ($1)", zip)
    debugger
    # https://forum.crystal-lang.org/t/how-to-dig-for-a-dynamic-json-value/3745/3
    json = Crawler.crawl_teams_from_zip(zip)
    # data = JSON::Parser.new(json).parse
    # all_teams = data["profile"]["region"]["all_regional_teams"].as_a

    # create_teams_for_zip(all_teams)
  end

  def create_teams_for_zip(team_array : Array(JSON::Any))
    mapped_data = team_array.map do |ele|
      {
        league:     ele["league"],
        long_name:  ele["team"],
        short_name: ele["short_name"],
        team_code:  ele["tricode"],
      }
    end
  end

  ###

  # the below should probably stay here
  def root(context)
    filename = "./src/view.html"
    context.response.content_type = "text/html"
    context.response.content_length = File.size(filename)
    File.open(filename) do |file|
      IO.copy(file, context.response)
    end
  end

  def health(context)
    context.response.content_type = "text/plain"
    context.response.print("Hello world! The time is #{Time.local}")
  end

  def request_hash(context)
    body = context.request.body.try(&.gets_to_end)
    # JSON::Parser.new(body.to_s).parse
  end

  struct NewContactMethod
    include JSON::Serializable
    getter contact_type : String
    getter contact_details : String
    getter enabled : Bool

    @contact_type : String
    @contact_details : String
    @enabled : Bool
  end
end
