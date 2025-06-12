require_relative 'spec_helper'
require_relative '../lib/send_response'
RSpec.describe SendResponse do
  describe '.send_response' do
    let(:messages) { ['Item 1', 'Item 2'] }
    let(:fake_response) { double('response', status_code: 202, headers: { 'X-Mock' => 'Yes' }) }

    it 'sends an email using SendGrid' do
      api_double = instance_double(SendGrid::API)
      client_double = double('client')
      mail_double = double('mail')
      send_double = double('send')

      allow(SendGrid::API).to receive(:new).and_return(api_double)
      allow(api_double).to receive(:client).and_return(client_double)
      allow(client_double).to receive(:mail).and_return(mail_double)
      allow(mail_double).to receive(:_).with('send').and_return(send_double)
      allow(send_double).to receive(:post).and_return(fake_response)

      response = SendResponse.send_response(messages)

      expect(SendGrid::API).to have_received(:new)
      expect(response.status_code).to eq(202)
    end
  end
end
