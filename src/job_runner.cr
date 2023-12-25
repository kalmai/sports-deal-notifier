require "tasker"
require "./emailer"

module JobRunner
  extend self
  include Emailer

  start_cron_jobs

  def start_cron_jobs
    Tasker.cron("30 5 * * *") { notify_of_deals } # 5:30 machine time
    puts "started cron job runners"
  end

  def notify_of_deals
    Emailer.sender(assemble_deals)
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
end
