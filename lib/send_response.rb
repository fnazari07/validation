require 'sendgrid-ruby'
include SendGrid
require 'json'
require 'pry'



class SendResponse
  def self.send_response(messages,count)
    list_content = "<ul>" + messages.map { |msg| "<li>#{msg}</li>" }.join + "</ul>"

    from = Email.new(email: 'it@empyreallogistics.com', name: "Validator")
    to = Email.new(email: 'rda@empyreallogistics.com', name: "RDA")

    
    subject = 'Results'
    content = Content.new(type: 'text/html', value: "<p>Here is your list for which folders to check:</p>#{list_content}Folders to check : #{count}")
    mail = Mail.new(from, subject, to, content)

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    
    puts response.status_code
    puts response.headers

    response
  end
end



