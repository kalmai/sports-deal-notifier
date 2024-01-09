require "mechanize"
require "selenium"

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
    # <p><strong>Offer valid the next day at participating Ohio Tim Hortons locations</strong></p>
    # </div>https://www.nhl.com/bluejackets/fans/gameday-central#gameday-promotions
    deals = page.css(%q{.nhl-c-card__content div div}).map(&.to_html).to_a
    puts deals
  end

  def scrape_js_required_sites(zip : String)
    driver = Selenium::Driver.for(:firefox, base_url: "http://localhost:4444")
    capabilities = Selenium::Firefox::Capabilities.new        # might be able to capture network requests inside of a proxy
    capabilities.firefox_options.args = ["-disable_encoding"] # = ["-headless"] # turns out it doesn't live in any response, we want to read the local storage for the data

    session = driver.create_session(capabilities)
    page = session.navigate_to("https://sports.directv.com/rsinfo")
    wait = Selenium::Helpers::Wait.new(timeout: 15.seconds, interval: 1.second)
    begin
      sleep 5
      element = session.find_element(:tag_name, "input")
      element.send_keys([zip, :tab])
      # net_data = session.document_manager.execute_script("var network = performance.getEntries() || {}; return network;")
      # need to decypher this code and extract it out and make it something useable perhaps:
      # https://gist.github.com/benjamingr/0433b52559ad61f6746be786525e97e8
      # issue is that the response we get back from the request that is fired off after tabbing
      # in selenium is what we want, the stuff presented in the page is nice, but the data provided
      # from the BE is what i want to scrape. a potential solution is to just take the script above,
      # deal with JS hell and make it work for capturing the request somehow and returning the data,
      # OR we can just figure out how to use proxies in the selenium gem and then we will receive the
      # response and should be able to parse it there. it seems like the shard supports proxies,
      # i just CBA to spend another day with JS selenium hell. future me, good f***ing luck.
      # element = session.find_element(:xpath, "/html/body/div/div/div[1]/div[2]/div/div/div/div[1]/div[1]/label")
      # element.send_keys(zip)
    rescue ex
      puts ex.message
    end
    # wait = Selenium::Helpers::Wait.new(timeout: 1.seconds, interval: 1.second)
    # session.document_manager.page_source # gets the html to parse, however it may be slow...
    storage = session.local_storage_manager.keys # this returns the local storage keys
    storage = session.local_storage_manager.item("userService.currentUser")
    session.delete
    storage

    # Use the wait object to wait until the search results are displayed.
    # We do this by checking if the element with the CSS selector "#search" is found on the page.
    # wait.until { session.find_element(:css, "input[placeholder=Zipcode]") }
    # html = Lexbor::Parser.new(page)
  end

  def crawl_teams_from_zip(zip : String)
    # page = Agent.get("https://www.ballysports.com/")
    # puts page.body
    # puts page.title
    # scrape_js_required_sites(zip)

    # it looks like bally has their website locked down UNLESS we can bypass the bot detection by loading the page with something like selenium i was reading might help?
    # it also looks like if ballysports via their ballyrsnfeed resource will not display the results IF they cannot provide you a subscription in said area code.
    # a solution might be to just use wikipedia? they have a page https://en.wikipedia.org/wiki/Sports_in_Ohio which lists all the major sports teams in a nice table, might already be a dependency which maps zip codes to states for crystal and then all we need to do is parse the table and store the state and team. f*** bally

    # puts page.body
    # form = page.css("input").to_a
    # puts form

    # placeholder="Zipcode"
    # form.field_with("email").value = "tester@example.com"
    # form.field_with("password").value = "xxxxxx"
    # agent.submit(form)

  end
end
