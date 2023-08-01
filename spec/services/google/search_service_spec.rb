# frozen_string_literal: true

require 'rails_helper'
require 'support/http_client_helpers'

RSpec.describe Google::SearchService, type: :service do
  describe '#search!' do
    context 'when search a keyword' do
      it 'perform a request against www.google.com' do
        outer_env = nil
        HttpClientHelpers.stub_http_adapter do |adapter, connection|
          allow(described_class).to receive(:http_client).and_return(connection)
          adapter.get('/search') do |env|
            outer_env = env
            200
          end
        end

        described_class.search!('hello world')
        expect(outer_env.url.host).to include('www.google.com')
      end

      it 'returns the result page html when the request succeeds' do
        html = '<html><title>Search results</title></html>'
        HttpClientHelpers.stub_http_adapter do |adapter, connection|
          allow(described_class).to receive(:http_client).and_return(connection)
          adapter.get('/search') { [200, { 'Content-Type': 'text/html' }, html] }
        end

        expect(described_class.search!('hello world')).to eq(html)
      end

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
