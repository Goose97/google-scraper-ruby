# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(KeywordDecorator) do
  describe '#top_ads_urls' do
    context 'given NO top ads search entries' do
      it 'returns an empty array' do
        keyword = Fabricate(:parsed_keyword) { keyword_search_entries(count: 0) }

        expect(keyword.top_ads_urls).to(be_empty)
      end
    end

    context 'given a list of top ads search entries' do
      # rubocop:disable RSpec/ExampleLength
      it 'returns all top ads URLs' do
        keyword = Fabricate(:parsed_keyword) { keyword_search_entries(count: 0) }

        Fabricate(
          :keyword_search_entry,
          kind: :ads,
          position: :top,
          keyword_id: keyword.id,
          urls: ['https://google.com', 'https://bing.com']
        )

        Fabricate(
          :keyword_search_entry,
          kind: :ads,
          position: :top,
          keyword_id: keyword.id,
          urls: ['https://www.ruby-lang.org/en/']
        )

        expect(keyword.top_ads_urls).to(contain_exactly('https://google.com', 'https://bing.com', 'https://www.ruby-lang.org/en/'))
      end
      # rubocop:enable RSpec/ExampleLength
    end
  end

  describe '#non_ads_urls' do
    context 'given NO non ads search entries' do
      it 'returns an empty array' do
        keyword = Fabricate(:parsed_keyword) { keyword_search_entries(count: 0) }

        expect(keyword.non_ads_urls).to(be_empty)
      end
    end

    context 'given a list of non ads search entries' do
      # rubocop:disable RSpec/ExampleLength
      it 'returns all non ads URLs' do
        keyword = Fabricate(:parsed_keyword) { keyword_search_entries(count: 0) }

        Fabricate(
          :keyword_search_entry,
          kind: :non_ads,
          keyword_id: keyword.id,
          urls: ['https://google.com', 'https://bing.com']
        )

        Fabricate(
          :keyword_search_entry,
          kind: :non_ads,
          keyword_id: keyword.id,
          urls: ['https://www.ruby-lang.org/en/']
        )

        expect(keyword.non_ads_urls).to(contain_exactly('https://google.com', 'https://bing.com', 'https://www.ruby-lang.org/en/'))
      end
      # rubocop:enable RSpec/ExampleLength
    end
  end
end
