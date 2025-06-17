require './lib/send_response'
require './lib/validation_service'
require 'pry'


validtions = Validation.new

result = validtions.validate
binding.pry
count = result.count
if result.nil?
  result = ["All docs uploaded."] 
  count = 0
end


SendResponse.send_response(result,count)
