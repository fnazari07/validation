require './lib/send_response'
require './lib/validation_service'
require 'pry'



# binding.pry
validtions = Validation.new

result = validtions.validate

if result.nil?
  result = ["All docs uploaded."]
end


SendResponse.send_response(result)
