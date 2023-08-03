# frozen_string_literal: true

require 'rails_helper'
require 'support/http_client_helpers'

RSpec.describe Google::SearchService, type: :service do
  describe '#search!' do
    context 'given a 2xx response' do
      it 'returns the result page html when the request succeeds' do
        html = '<html><title>Search results</title></html>'
        service = described_class.new

        HttpClientHelpers.stub_http_adapter do |adapter, connection|
          allow(service).to receive(:http_client).and_return(connection)
          adapter.get('/search') { [200, { 'Content-Type': 'text/html' }, html] }
        end

        expect(service.search!('hello world')).to eq(html)
      end
    end

    context 'given a 4xx response' do
      it 'raises GoogleScraperRuby::Errors::SearchError' do
        service = described_class.new

        HttpClientHelpers.stub_http_adapter do |adapter, connection|
          allow(service).to receive(:http_client).and_return(connection)
          adapter.get('/search') { [429, {}, 'Too Many Requests'] }
        end

        expect do
          service.search!('hello world')
        end.to raise_error(GoogleScraperRuby::Errors::SearchError)
      end
    end

    context 'given a 5xx response' do
      it 'raises GoogleScraperRuby::Errors::SearchError' do
        service = described_class.new

        HttpClientHelpers.stub_http_adapter do |adapter, connection|
          allow(service).to receive(:http_client).and_return(connection)
          adapter.get('/search') { [500, {}, 'Internal Server Error'] }
        end

        expect do
          service.search!('hello world')
        end.to raise_error(GoogleScraperRuby::Errors::SearchError)
      end
    end

    context 'given a connection fail issue' do
      it 'raises GoogleScraperRuby::Errors::SearchError' do
        service = described_class.new

        HttpClientHelpers.stub_http_adapter do |adapter, connection|
          allow(service).to receive(:http_client).and_return(connection)
          adapter.get('/search') { raise Faraday::ConnectionFailed }
        end

        expect do
          service.search!('hello world')
        end.to raise_error(GoogleScraperRuby::Errors::SearchError)
      end
    end
  end
end
