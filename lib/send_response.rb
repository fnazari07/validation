require 'sendgrid-ruby'
include SendGrid
require 'json'
require 'pry'



class SendResponse
  def self.send_response(messages)
    list_content = "<ul>" + messages.map { |msg| "<li>#{msg}</li>" }.join + "</ul>"

    from = Email.new(email: 'it@empyreallogistics.com', name: "Validator")
    to = Email.new(email: 'mfaisalnazari@empyreallogistics.com', name: "Test")
    # to = Email.new(email: 'CMillard@empyreallogistics.com', name: "Test")
    
    subject = 'Results'
    content = Content.new(type: 'text/html', value: "<p>Here is your list for which folders to check:</p>#{list_content}Folders to check : #{messages.count}")
    mail = Mail.new(from, subject, to, content)

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    
    puts response.status_code
    puts response.headers

    response
  end
end



