require 'faraday'
require 'json'
require 'pry'
require 'date'

class Validation

    def conn
        Faraday.new(url: "https://empyreallogistics.files.com/api/rest/v1/folders") do |faraday|
        faraday.headers["X-FilesAPI-Key"] = ENV["FILES_API_KEY_P"]
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


    def validate
        base_folder = "Financial_institution_Reporting/Sites"
    
        depth = 5 
        error_folders = []
        all_paths = traverse_paths(base_folder, depth)
        today_str = Date.today.strftime("%Y-%m-%d")
        filtered_paths = all_paths.reject { |path| path.include?("US National") }
        filtered_paths.each do |path|
            encoded = encode_path(path)
            folder_items = get_url(encoded)

            next if folder_items.nil? || folder_items.empty?

            csv_found = false
            pdf_found = false

            folder_items.each do |item|
            next unless item[:type] == "file"
            name = item[:display_name] || item[:path]

            csv_found = true if name.end_with?(".csv") && name.include?(today_str)
            pdf_found = true if name.end_with?(".pdf") && name.include?(today_str)

            break if csv_found && pdf_found
            end

            unless csv_found && pdf_found
            error_folders << path
            end
    end

    # binding.pry
    error_folders
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


# a = Validation.new
# a.validate

# # binding.pry
# puts 'done'
