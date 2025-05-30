require 'faraday'
require 'json'
require 'pry'

class Validation
    attr_reader :errors, :paths
    attr_accessor :errors, :paths

    def initialize
    @errors = []
    @paths = []
    end

    def validate
       first_paths = []
        folder_path = "Financial_institution_Reporting/Sites"
        result = get_url(folder_path)
        result.each do |site|
          first_paths << site[:path]
        #   binding.pry
        end
        next_paths = []
        first_paths.each do |p|
            encoded_path = encode_path(p)
            result = get_url(encoded_path)
            result.each do |fi|
                next_paths << fi[:path]
            end
        end
        third_paths = []
        next_paths.each do |p|
            encoded_path = encode_path(p)
            result = get_url(encoded_path)
            if result != nil 
                result.each do |fi|
                    
                    if fi[:type] == "directory"
                        third_paths << fi[:path] && next_paths << fi[:path]
                    end
                end
            end
            
        end
        final_path = []
        third_paths.each do |p|
            encoded_path = encode_path(p)
            result = get_url(encoded_path)
            if result != nil 
                result.each do |fi|
                    
                    if fi[:type] == "directory"
                        final_path << fi[:path] && next_paths << fi[:path]
                    end
                end
            end
            
        end
        binding.pry

    end
    

    def conn
        Faraday.new(url: "https://elarchived.files.com/api/rest/v1/folders") do |faraday|
        faraday.headers["X-FilesAPI-Key"] = '9c80cb58542'
        faraday.headers["Content-Type"] = "application/json"
        faraday.headers["Accept"] = "application/json"
        end
    end


    def get_url(url)
        response = conn.get(url)
        data = JSON.parse(response.body, symbolize_names: true)
        data
    end

    def encode_path(path)
        path.split('/').map { |segment| URI::DEFAULT_PARSER.escape(segment) }.join('/')
    end
end

a = Validation.new
a.validate
# binding.pry
puts 'done'

