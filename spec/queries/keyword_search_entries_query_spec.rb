# frozen_string_literal: true

require 'rails_helper'

describe(KeywordSearchEntriesQuery) do
  describe '#top_ads_count' do
    context 'given a keyword with NO top ads entries' do
      it 'returns 0' do
        keyword = Fabricate(:parsed_keyword) { keyword_search_entries(count: 0) }
        Fabricate.times(2, :keyword_search_entry, kind: :ads, position: :bottom, keyword_id: keyword.id)

        query = described_class.new.with_keyword(keyword.id)

        expect(query.top_ads_count).to(eq(0))
      end
    end

    context 'given a keyword with a list of top ads entries' do
      it 'returns the number of top ads entries' do
        keyword = Fabricate(:parsed_keyword) { keyword_search_entries(count: 0) }
        Fabricate.times(2, :keyword_search_entry, kind: :ads, position: :top, keyword_id: keyword.id)

        query = described_class.new.with_keyword(keyword.id)

        expect(query.top_ads_count).to(eq(2))
      end
    end
  end

  describe '#total_ads_count' do
    context 'given a keyword with NO ads entries' do
      it 'returns 0' do
        keyword = Fabricate(:parsed_keyword) { keyword_search_entries(count: 0) }
        Fabricate.times(2, :keyword_search_entry, kind: :non_ads, keyword_id: keyword.id)

        query = described_class.new.with_keyword(keyword.id)

        expect(query.total_ads_count).to(eq(0))
      end
    end

    context 'given a keyword with a list of ads entries' do
      it 'returns the number of ads entries' do
        keyword = Fabricate(:parsed_keyword) { keyword_search_entries(count: 0) }
        Fabricate.times(2, :keyword_search_entry, kind: :ads, keyword_id: keyword.id)

        query = described_class.new.with_keyword(keyword.id)

        expect(query.total_ads_count).to(eq(2))
      end
    end
  end

  describe '#non_ads_count' do
    context 'given a keyword with NO non-ads entries' do
      it 'returns 0' do
        keyword = Fabricate(:parsed_keyword) { keyword_search_entries(count: 0) }
        Fabricate.times(2, :keyword_search_entry, kind: :ads, keyword_id: keyword.id)

        query = described_class.new.with_keyword(keyword.id)

        expect(query.non_ads_count).to(eq(0))
      end
    end

    context 'given a keyword with a list of non-ads entries' do
      it 'returns the number of non-ads entries' do
        keyword = Fabricate(:parsed_keyword) { keyword_search_entries(count: 0) }
        Fabricate.times(2, :keyword_search_entry, kind: :non_ads, keyword_id: keyword.id)

        query = described_class.new.with_keyword(keyword.id)

        expect(query.non_ads_count).to(eq(2))
      end
    end
  end
end
