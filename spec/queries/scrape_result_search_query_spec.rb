# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(ScrapeResultSearchQuery) do
  describe '#call' do
    context 'given :exact query type' do
      it 'returns all URLs satisfy the query pattern and their corresponding keyword_id' do
        url = 'https://google.com'
        keyword = Fabricate(:parsed_keyword) { keyword_search_entries(count: 0) }
        Fabricate(:keyword_search_entry, urls: [url], keyword_id: keyword.id)
        Fabricate(:keyword_search_entry, urls: ['https://ruby-lang.org'], keyword_id: keyword.id)

        result = described_class.new(query_type: :exact, pattern: url).call

        expect(result).to(contain_exactly({ keyword_id: keyword.id, urls: [url] }))
      end
    end

    context 'given :partial query type' do
      it 'returns all URLs satisfy the query pattern and their corresponding keyword_id' do
        url = 'https://google.com'
        keyword = Fabricate(:parsed_keyword) { keyword_search_entries(count: 0) }
        Fabricate(:keyword_search_entry, urls: [url], keyword_id: keyword.id)
        Fabricate(:keyword_search_entry, urls: ['https://ruby-lang.org'], keyword_id: keyword.id)

        result = described_class.new(query_type: :partial, pattern: 'google').call

        expect(result).to(contain_exactly({ keyword_id: keyword.id, urls: [url] }))
      end
    end

    context 'given :pattern query type' do
      it 'returns all URLs satisfy the query pattern and their corresponding keyword_id' do
        url = 'https://google.com'
        keyword = Fabricate(:parsed_keyword) { keyword_search_entries(count: 0) }
        Fabricate(:keyword_search_entry, urls: [url], keyword_id: keyword.id)
        Fabricate(:keyword_search_entry, urls: ['https://ruby-lang.org'], keyword_id: keyword.id)

        result = described_class.new(query_type: :pattern, pattern: 'go{2}\w+\.com$').call

        expect(result).to(contain_exactly({ keyword_id: keyword.id, urls: [url] }))
      end
    end
  end
end
