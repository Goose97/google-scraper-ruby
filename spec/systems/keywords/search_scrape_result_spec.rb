# frozen_string_literal: true

require 'rails_helper'

describe 'Search scrape result', type: :system do
  context 'given VALID params' do
    # rubocop:disable RSpec/NoExpectationExample
    it 'displays search result' do
      keyword = Fabricate(:parsed_keyword) { keyword_search_entries(count: 0) }
      Fabricate(:keyword_search_entry, urls: ['https://ruby-lang.org', 'https://ruby-doc.org'], keyword_id: keyword.id)

      visit(search_keywords_path({ search: 'ruby', query_type: 'partial' }))

      page.assert_selector("[data-testid='search_result_search_term']", text: 'ruby', count: 1)
      page.assert_selector("[data-testid='search_result_query_type']", text: 'partial', count: 1)
      page.assert_selector("[data-testid='search_result_total_matched_urls']", text: '2', count: 1)

      within("div[data-keyword-id='#{keyword.id}']") do |item|
        item.assert_selector("[data-testid='search_result_keyword_content']", text: keyword.content, count: 1)
        item.assert_selector("ul[data-testid='search_result_url_list'] > li", count: 2)
      end
    end
    # rubocop:enable RSpec/NoExpectationExample
  end
end
