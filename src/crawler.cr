require "mechanize"

module Crawler
  extend self

  Agent = Mechanize.new

  def crawl_page(url : String)
    page = Agent.get(url)
    deals = page.css(%q{.nhl-c-card__content div div}).map(&.to_html).to_a
    puts deals
  end
end

#     <div class="nhl-c-card__content">
#      <div class="fa-text fa-text--fulldescription">
#        <h3 class="fa-text__title">Tim Hortons We Win, You Win!</h3>
#        <div class="fa-text__body"><p>When the Blue Jackets win at home, fans can get a free coffee! Just show the social media post at Tim Hortons to redeem!</p>
#
#<p><strong>Offer valid the next day at participating Ohio Tim Hortons locations</strong></p>
#</div>https://www.nhl.com/bluejackets/fans/gameday-central#gameday-promotions
