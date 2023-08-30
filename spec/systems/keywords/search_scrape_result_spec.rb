# frozen_string_literal: true

require 'rails_helper'

describe 'Search scrape result', type: :system do
  context 'given VALID params' do
    it 'displays search result' do
      keyword = Fabricate(:parsed_keyword) { keyword_search_entries(count: 0) }
      Fabricate(:keyword_search_entry, urls: ['https://ruby-lang.org', 'https://ruby-doc.org'], keyword_id: keyword.id)

      visit(search_keywords_path({ search: 'ruby', query_type: 'partial' }))

      expect(find("[data-testid='search_result_total_matched_urls']")).to(have_content(2))
      expect(find("[data-testid='search_result_keyword_content']")).to(have_content(keyword.content))

      within("div[data-keyword-id='#{keyword.id}']") do |item|
        item.assert_selector("ul[data-testid='search_result_url_list'] > li", count: 2)
      end
    end
  end
end
