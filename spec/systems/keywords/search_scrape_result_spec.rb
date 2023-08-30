# frozen_string_literal: true

require 'rails_helper'

describe 'Search scrape result', type: :system do
  context 'given VALID params' do
    # rubocop:disable RSpec/NoExpectationExample, RSpec/ExampleLength
    it 'displays search result' do
      keyword = Fabricate(:parsed_keyword) { keyword_search_entries(count: 0) }
      Fabricate(:keyword_search_entry, urls: ['https://ruby-lang.org', 'https://ruby-doc.org'], keyword_id: keyword.id)

      visit(root_path)
      within('form[data-testid="scrape-result-search-form"]') do
        fill_in('search', with: 'ruby')
        select(I18n.t('keywords.query_type.partial'), from: 'query_type')

        click_button I18n.t('shared.button.search')
      end

      page.assert_selector("[data-testid='search_result_search_term']", text: 'ruby', count: 1)
      page.assert_selector("[data-testid='search_result_query_type']", text: 'partial', count: 1)
      page.assert_selector("[data-testid='search_result_total_matched_urls']", text: '2', count: 1)

      within("div[data-keyword-id='#{keyword.id}']") do |item|
        item.assert_selector("[data-testid='search_result_keyword_content']", text: keyword.content, count: 1)
        item.assert_selector("ul[data-testid='search_result_url_list'] > li", count: 2)
      end
    end
    # rubocop:enable RSpec/NoExpectationExample, RSpec/ExampleLength
  end
end
