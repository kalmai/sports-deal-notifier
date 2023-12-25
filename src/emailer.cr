require "json"

module Emailer
  extend self

  def sender(props)
    props.each do |prop|
      resp = HTTP::Client.post("https://api.sendgrid.com/v3/mail/send", request_headers, payload(prop))
      puts resp.status_code
    end
  end

  def request_headers
    HTTP::Headers{
      "Authorization" => "Bearer #{ENV.fetch("SEND_GRID_API_KEY")}",
      "Content-Type" => "application/json"
    }
  end

  def payload(prop : EmailProperties)
    {
      personalizations: [{ to: [{ email: prop.address }] }],
      from: { email: ENV.fetch("HOST_EMAIL_ADDRESS")},
      subject: prop.subject,
      content: [{ type: "text/plain", value: prop.content }]
    }.to_json
  end

  record EmailProperties, address : String, subject : String, content : String
end
