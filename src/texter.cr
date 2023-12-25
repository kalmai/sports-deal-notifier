require "json"

module Texter
  extend self

  def sender(props)
    props.each do |prop|
      client = HTTP::Client.new(URI.parse("https://api.twilio.com"))
      client.basic_auth(ENV.fetch("TWILIO_ACCOUNT_SID"), ENV.fetch("TWILIO_API_KEY"))
      request = HTTP::Request.new(
        "POST",
        "https://api.twilio.com/2010-04-01/Accounts/#{ENV.fetch("TWILIO_ACCOUNT_SID")}/Messages.json",
        request_headers,
        payload(prop)
      )
      resp = client.exec(request)
      puts resp.status_code
    end
  end

  def request_headers
    HTTP::Headers { "Content-Type" => "application/x-www-form-urlencoded" }
  end

  def payload(prop : TextProperties)
    "From=#{ENV.fetch("HOST_PHONE_NUMBER")}&To=#{prop.phone_num}&Body=#{prop.content}"
  end

  record TextProperties, phone_num : String, content : String
end
