require 'faraday'
require 'json'
require 'pry'

class Validation

    def initialize
    @errors = []
    end

    def validate
        folder_path = "folders/Financial_institution_Reporting/Sites"
        result = get_url(folder_path)
        @errors = result.first[:path]
        binding.pry
        # result.each do |site|
        #   @errors = site[:path]
        #   # binding.pry

        # end
    end


    def conn
        Faraday.new(url: "https://elarchived.files.com/api/rest/v1") do |faraday|
        faraday.headers["X-FilesAPI-Key"] = 
        faraday.headers["Content-Type"] = "application/json"
        faraday.headers["Accept"] = "application/json"
        end
    end


    def get_url(url)
        response = conn.get(url)
        data = JSON.parse(response.body, symbolize_names: true)
        data
    end
end

a = Validation.new
a.validate
# binding.pry
puts 'done'

