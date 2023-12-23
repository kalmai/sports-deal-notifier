require "json"

module EmailerA
  extend self

  def sender(addresses)
    resp = HTTP::Client.post("https://api.sendgrid.com/v3/mail/send", request_headers, payload("something@gmail.com", "heloworldmao", "hellomehowareyoudoingtodaybruvinitbigben"))
    puts resp.status
  end

  def request_headers
    HTTP::Headers{
      "Authorization" => "Bearer #{ENV.fetch("SEND_GRID_API_KEY")}",
      "Content-Type" => "application/json"
    }
  end

  def payload(email : String, subject : String, email_body : String)
    {
      personalizations: [{ to: [{ email: email }] }],
      from: { email: "something@gmail.com"},
      subject: subject,
      content: [{ type: "text/plain", value: email_body }]
    }.to_json
  end
end
