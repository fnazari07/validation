require_relative 'spec_helper'
require_relative '../lib/validation_service'
require 'date'



RSpec.describe Validation do
  before(:each) do
    @service = Validation.new

    stub_request(:get, "https://empyreallogistics.files.com/api/rest/v1/folders/Financial_institution_Reporting/Sites")
      .to_return(
        status: 200,
        body: JSON.generate([
          { type: "directory", path: "Financial_institution_Reporting/Sites/Folder1" },
          { type: "file", display_name: "somefile.txt", path: "Financial_institution_Reporting/Sites/somefile.txt" }
        ])
      )

    stub_request(:get, %r{https://empyreallogistics.files.com/api/rest/v1/folders/Financial_institution_Reporting/Sites/Folder1})
      .to_return(
        status: 200,
        body: JSON.generate([
          { type: "file", display_name: "#{Date.today.strftime('%Y-%m-%d')}_report.csv", path: "Financial_institution_Reporting/Sites/Folder1/#{Date.today.strftime('%Y-%m-%d')}_report.csv" },
          { type: "file", display_name: "#{Date.today.strftime('%Y-%m-%d')}_summary.pdf", path: "Financial_institution_Reporting/Sites/Folder1/#{Date.today.strftime('%Y-%m-%d')}_summary.pdf" }
        ])
      )
  end

  describe '#conn' do
    it 'returns a Faraday connection object' do
      expect(@service.conn).to be_a(Faraday::Connection)
    end
  end

  describe '#get_url' do
    it 'returns parsed JSON data from the URL' do
      response = @service.get_url("Financial_institution_Reporting/Sites")
      expect(response).to be_an(Array)
      expect(response.first).to have_key(:type)
    end
  end

  describe '#encode_path' do
    it 'encodes URL path segments' do
      raw_path = "Financial institution Reporting/test folder"
      encoded = @service.encode_path(raw_path)
      expect(encoded).to eq("Financial%20institution%20Reporting/test%20folder")
    end
  end

  describe '#validate' do
    it 'returns no error folders if both csv and pdf files are found for today' do
      allow(@service).to receive(:traverse_paths).and_return([
        "Financial_institution_Reporting/Sites/Folder1"
      ])

      result = @service.validate
      expect(result).to be_an(Array)
      expect(result).not_to include("Financial_institution_Reporting/Sites/Folder1")
    end

    it 'returns folders missing csv or pdf for today' do
      stub_request(:get, %r{https://empyreallogistics.files.com/api/rest/v1/folders/Financial_institution_Reporting/Sites/Folder2})
        .to_return(
          status: 200,
          body: JSON.generate([
            { type: "file", display_name: "#{Date.today.strftime('%Y-%m-%d')}_report.csv" }
          ])
        )

      allow(@service).to receive(:traverse_paths).and_return([
        "Financial_institution_Reporting/Sites/Folder1",
        "Financial_institution_Reporting/Sites/Folder2"
      ])

      result = @service.validate
      expect(result).to include("Financial_institution_Reporting/Sites/Folder2")
      expect(result).not_to include("Financial_institution_Reporting/Sites/Folder1")
    end
  end
end