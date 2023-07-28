# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Google::SearchService, type: :service do
  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:stubbed_conn) { Faraday.new { |b| b.adapter(:test, stubs) } }

  describe '#search!' do
    before(:each) do
      allow(described_class).to receive(:build_conn).and_return(stubbed_conn)
    end

    context 'when search a keyword' do
      it 'perform a request against www.google.com' do
        outer_env = nil
        stubs.get('/search') do |env|
          outer_env = env
          200
        end

        described_class.search!('hello world')
        expect(outer_env.url.host).to include('www.google.com')
      end

      it 'returns the result page html when the request succeeds' do
        html = '<html><title>Search results</title></html>'
        stubs.get('/search') do |_env|
          [
            200,
            { 'Content-Type': 'text/html' },
            html
          ]
        end

        expect(described_class.search!('hello world')).to eq(html)
      end

      it 'raise Google::SearchServiceError if the request returns a 4xx/5xx status code' do
        stubs.get('/search') { [429, {}, 'Too Many Requests'] }
        expect do
          described_class.search!('hello world')
        end.to raise_error(Google::SearchServiceError)

        stubs.get('/search') { [500, {}, 'Internal Server Error'] }
        expect do
          described_class.search!('hello world')
        end.to raise_error(Google::SearchServiceError)
      end

      it "raise Google::SearchServiceError if it can't connect to the host" do
        stubs.get('/search') { raise Faraday::ConnectionFailed }
        expect do
          described_class.search!('hello world')
        end.to raise_error(Google::SearchServiceError)
      end
    end
  end
end
