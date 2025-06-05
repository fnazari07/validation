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
                        third_paths << fi[:path]
                        next_paths << fi[:path]
                    end
                end
            end
            
        end
        iv_paths = []
        third_paths.each do |p|
            encoded_path = encode_path(p)
            result = get_url(encoded_path)
            if result != nil 
                result.each do |fi|
                    
                    if fi[:type] == "directory"
                        iv_paths << fi[:path]
                        next_paths << fi[:path]
                    end
                end
            end
            
        end

        final_path = []
        iv_paths.each do |p|
            encoded_path = encode_path(p)
            result = get_url(encoded_path)
            if result != nil 
                result.each do |fi|
                    
                    if fi[:type] == "directory"
                        final_path << fi[:path]
                        next_paths << fi[:path]
                    end
                end
            end
            
        end
        next_paths

    end
    

    def conn
        Faraday.new(url: "https://elarchived.files.com/api/rest/v1/folders") do |faraday|
        faraday.headers["X-FilesAPI-Key"] = ENV["FILES_API_KEY"]
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



    def validate1
    base_folder = "Financial_institution_Reporting/Sites"
    depth = 5  

    all_paths = traverse_paths(base_folder, depth)

    end

   
    
    def traverse_paths(start_path, levels)
        paths = [start_path]
        all_collected_paths = []

        levels.times.with_index do |_, level_index|
            next_level_paths = []

            paths.each do |path|
            encoded = encode_path(path)
            result = get_url(encoded)
            next unless result

            result.each do |item|
                if item[:type] == "directory"
                next_level_paths << item[:path]
                all_collected_paths << item[:path] if level_index >= 1
                end
            end
            end

            paths = next_level_paths
        end

            all_collected_paths
        end

end


a = Validation.new
test = a.validate
test_2 = a.validate1

binding.pry
puts 'done'




#  def validate
#        first_paths = []
#         folder_path = "Financial_institution_Reporting/Sites"
#         result = get_url(folder_path)
#         result.each do |site|
#           first_paths << site[:path]
#         #   binding.pry
#         end
#         next_paths = []
#         first_paths.each do |p|
#             encoded_path = encode_path(p)
#             result = get_url(encoded_path)
#             result.each do |fi|
#                 next_paths << fi[:path]
#             end
#         end
#         third_paths = []
#         next_paths.each do |p|
#             encoded_path = encode_path(p)
#             result = get_url(encoded_path)
#             if result != nil 
#                 result.each do |fi|
                    
#                     if fi[:type] == "directory"
#                         third_paths << fi[:path]
#                         next_paths << fi[:path]
#                     end
#                 end
#             end
            
#         end
#         iv_paths = []
#         third_paths.each do |p|
#             encoded_path = encode_path(p)
#             result = get_url(encoded_path)
#             if result != nil 
#                 result.each do |fi|
                    
#                     if fi[:type] == "directory"
#                         iv_paths << fi[:path]
#                         next_paths << fi[:path]
#                     end
#                 end
#             end
            
#         end

#         final_path = []
#         iv_paths.each do |p|
#             encoded_path = encode_path(p)
#             result = get_url(encoded_path)
#             if result != nil 
#                 result.each do |fi|
                    
#                     if fi[:type] == "directory"
#                         final_path << fi[:path]
#                         next_paths << fi[:path]
#                     end
#                 end
#             end
            
#         end
#         next_paths

#     end
