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
    crawl_deal_pages
    Tasker.cron("30 5 * * *") { notify_of_deals } # 5:30 machine time
    puts "started cron job runners"
  end

  def crawl_deal_pages
    Crawler.crawl_page("https://www.nhl.com/bluejackets/fans/gameday-central#gameday-promotions")
  end

  def notify_of_deals
    Emailer.sender(assemble_deals)
    Texter.sender(assemble_text_deals)
  end

  def assemble_deals
    assembled_deals = [] of Emailer::EmailProperties

    rs = Database::Connection.query("select * from emails")
    rs.each do
      email, freq = rs.read(String, Int32)
      assembled_deals << Emailer::EmailProperties.new(email, "not using this #{freq}", "congratuationas youvewonomg")
    end

    assembled_deals
  end

  def assemble_text_deals
    assembled_deals = [] of Texter::TextProperties

    rs = Database::Connection.query("select * from emails")
    rs.each do
      email, freq = rs.read(String, Int32)
      assembled_deals << Texter::TextProperties.new(email, "congratuationas youvewonomg")
    end

    assembled_deals
  end
end
