require "mechanize"

module Crawler
  extend self

  Agent = Mechanize.new

  def crawl_blue_jackets_page(url : String)
    page = Agent.get(url)
#     <div class="nhl-c-card__content">
#      <div class="fa-text fa-text--fulldescription">
#        <h3 class="fa-text__title">Tim Hortons We Win, You Win!</h3>
#        <div class="fa-text__body"><p>When the Blue Jackets win at home, fans can get a free coffee! Just show the social media post at Tim Hortons to redeem!</p>
#
#<p><strong>Offer valid the next day at participating Ohio Tim Hortons locations</strong></p>
#</div>https://www.nhl.com/bluejackets/fans/gameday-central#gameday-promotions
    deals = page.css(%q{.nhl-c-card__content div div}).map(&.to_html).to_a
    puts deals
  end

  def crawl_teams_from_zip(zip : String)
    #page = Agent.get("https://www.ballysports.com/")
    http_page = HTTP::Client.get("https://ballyrsnfeed.channelfinder.net/?zip=#{zip}")
    puts http_page.body

    # it looks like bally has their website locked down UNLESS we can bypass the bot detection by loading the page with something like selenium i was reading might help?
    # it also looks like if ballysports via their ballyrsnfeed resource will not display the results IF they cannot provide you a subscription in said area code.
    # a solution might be to just use wikipedia? they have a page https://en.wikipedia.org/wiki/Sports_in_Ohio which lists all the major sports teams in a nice table, might already be a dependency which maps zip codes to states for crystal and then all we need to do is parse the table and store the state and team. f*** bally

    #puts page.body
    #form = page.css("input").to_a
    #puts form

    # placeholder="Zipcode"
    # form.field_with("email").value = "tester@example.com"
    # form.field_with("password").value = "xxxxxx"
    # agent.submit(form)

  end
end

