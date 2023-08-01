# frozen_string_literal: true

require 'rails_helper'
require 'support/http_client_helpers'

RSpec.describe Google::SearchService, type: :service do
  describe '#search!' do
    context 'given a successful request' do
      it 'returns the result page html when the request succeeds' do
        html = '<html><title>Search results</title></html>'
        HttpClientHelpers.stub_http_adapter do |adapter, connection|
          allow(described_class).to receive(:http_client).and_return(connection)
          adapter.get('/search') { [200, { 'Content-Type': 'text/html' }, html] }
        end

        expect(described_class.search!('hello world')).to eq(html)
      end
    end

    context 'given a failed request' do
      it 'raise GoogleScraperRuby::Errors::SearchServiceError if the request returns a 4xx status code' do
        HttpClientHelpers.stub_http_adapter do |adapter, connection|
          allow(described_class).to receive(:http_client).and_return(connection)
          adapter.get('/search') { [429, {}, 'Too Many Requests'] }
        end

        expect do
          described_class.search!('hello world')
        end.to raise_error(GoogleScraperRuby::Errors::SearchServiceError)
      end

      it 'raise GoogleScraperRuby::Errors::SearchServiceError if the request returns a 5xx status code' do
        HttpClientHelpers.stub_http_adapter do |adapter, connection|
          allow(described_class).to receive(:http_client).and_return(connection)
          adapter.get('/search') { [500, {}, 'Internal Server Error'] }
        end

        expect do
          described_class.search!('hello world')
        end.to raise_error(GoogleScraperRuby::Errors::SearchServiceError)
      end

      it "raise GoogleScraperRuby::Errors::SearchServiceError if it can't connect to the host" do
        HttpClientHelpers.stub_http_adapter do |adapter, connection|
          allow(described_class).to receive(:http_client).and_return(connection)
          adapter.get('/search') { raise Faraday::ConnectionFailed }
        end

        expect do
          described_class.search!('hello world')
        end.to raise_error(GoogleScraperRuby::Errors::SearchServiceError)
      end
    end
  end
end
