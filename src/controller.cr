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
    p! request_hash = request_hash(context)
    # zipcode_id = find_zipcode_id(request_hash["zipcode"].as_s) # we will use this for the user eventually
    contact_methods = [] of String# request_hash["contact_methods"].as_a.map do |set|
    contact_hash = JSON.parse(request_hash.to_s)["contact_methods"].as_a.map(&.as_h).map do |k|
      {(k.keys.first) => k[k.keys.first].as_s}
    end
    debugger
    # Hash(String, String).from_json(body.to_s)
    # today we learned that it's easier to just work with tuples than hashes in crystal lang?
    contact_methods.each do |key|
      Database::Connection.exec("insert into contact_method (contact_type, contact_detail, enabled) values ($1, $2, $3)", key, "", true)
    end
    JobRunner.notify_of_deals
  end

  def find_zipcode_id(zip : String)
    # need to save data to our zipcode table in the future and check with db.query later
    # dont execute below if db.result otherwise crawl ballysport for the teams

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
end
