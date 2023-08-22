# frozen_string_literal: true

require 'rails_helper'

describe(KeywordStats) do
  context 'given a keyword with NO search entries' do
    it 'returns nil' do
      keyword = Fabricate(:parsed_keyword) { keyword_search_entries(count: 0) }

      expect(keyword.keyword_stats).to(be_nil)
    end
  end

  describe '#top_ads_count' do
    context 'given a keyword with NO top ads entries' do
      it 'returns 0' do
        keyword = Fabricate(:parsed_keyword) { keyword_search_entries(count: 0) }

        Fabricate.times(2, :keyword_search_entry, kind: :ads, position: :bottom, keyword_id: keyword.id)

        expect(keyword.keyword_stats.top_ads_count).to(eq(0))
      end
    end

    context 'given a keyword with a list of top ads entries' do
      it 'returns the number of top ads entries' do
        keyword = Fabricate(:parsed_keyword) { keyword_search_entries(count: 0) }

        Fabricate.times(2, :keyword_search_entry, kind: :ads, position: :top, keyword_id: keyword.id)

        expect(keyword.keyword_stats.top_ads_count).to(eq(2))
      end
    end
  end

  describe '#total_ads_count' do
    context 'given a keyword with NO ads entries' do
      it 'returns 0' do
        keyword = Fabricate(:parsed_keyword) { keyword_search_entries(count: 0) }

        Fabricate.times(2, :keyword_search_entry, kind: :non_ads, keyword_id: keyword.id)

        expect(keyword.keyword_stats.total_ads_count).to(eq(0))
      end
    end

    context 'given a keyword with a list of ads entries' do
      it 'returns the number of ads entries' do
        keyword = Fabricate(:parsed_keyword) { keyword_search_entries(count: 0) }

        Fabricate.times(2, :keyword_search_entry, kind: :ads, keyword_id: keyword.id)

        expect(keyword.keyword_stats.total_ads_count).to(eq(2))
      end
    end
  end

  describe '#non_ads_count' do
    context 'given a keyword with NO non-ads entries' do
      it 'returns 0' do
        keyword = Fabricate(:parsed_keyword) { keyword_search_entries(count: 0) }

        Fabricate.times(2, :keyword_search_entry, kind: :ads, keyword_id: keyword.id)

        expect(keyword.keyword_stats.non_ads_count).to(eq(0))
      end
    end

    context 'given a keyword with a list of non-ads entries' do
      it 'returns the number of non-ads entries' do
        keyword = Fabricate(:parsed_keyword) { keyword_search_entries(count: 0) }

        Fabricate.times(2, :keyword_search_entry, kind: :non_ads, keyword_id: keyword.id)

        expect(keyword.keyword_stats.non_ads_count).to(eq(2))
      end
    end
  end
end
