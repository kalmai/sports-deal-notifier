require "tasker"
require "./emailer"
require "./texter"
require "./crawler"

module JobRunner
  extend self

  include Emailer
  include Texter

  start_cron_jobs

  def start_cron_jobs
    # crawl_deal_pages
    # notify_of_deals
    Tasker.cron("30 5 * * *") { notify_of_deals } # 5:30 machine time
    puts "started cron job runners"
  end

  def crawl_deal_pages
    # Crawler.crawl_page("https://www.nhl.com/bluejackets/fans/gameday-central#gameday-promotions")
    # Crawler.crawl_teams_from_zip("43026")
    # Crawler.crawl_teams_from_zip("15106")
  end

  def find_teams_for_zip(zip : String)
    # need to save data to our zipcode table in the future and check with db.query later
    # return db.result if db.result otherwise crawl ballysport for the teams
    # Crawler.crawl_teams_from_zip(zip)
  end

  def notify_of_deals
    Emailer.sender(assemble_deals)
    # Texter.sender(assemble_text_deals)
  end

  def assemble_deals
    assembled_deals = [] of Emailer::EmailProperties

    rs = Database::Connection.query("select contact_detail from contact_method (select * from contact_method where contact_type = 'email') where enabled = true")
    rs.each do
      email = rs.read(String)
      assembled_deals << Emailer::EmailProperties.new(email, "subject", "message")
    end

    assembled_deals
  end

  def assemble_text_deals
    assembled_deals = [] of Texter::TextProperties

    rs = Database::Connection.query("select contact_detail from contact_method where contact_type = 'phone_number' and enabled = true")
    rs.each do
      phone_number = rs.read(String)
      assembled_deals << Texter::TextProperties.new(phone_number, "congratuationas youvewonomg")
    end

    assembled_deals
  end
end
