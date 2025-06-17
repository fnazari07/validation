require './lib/send_response'
require './lib/validation_service'
require 'pry'



# binding.pry
validtions = Validation.new

result = validtions.validate
count = result.count
if result.nil?
  result = ["All docs uploaded."] 
  count = 0
end


SendResponse.send_response(result,count)
