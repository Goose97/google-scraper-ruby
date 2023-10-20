# frozen_string_literal: true

require 'rails_helper'

describe 'Search scrape result', type: :system do
  context 'given VALID params' do
    # rubocop:disable RSpec/ExampleLength
    it 'displays search result' do
      user = Fabricate(:user)
      keyword_a = Fabricate(:parsed_keyword, user: user) { keyword_search_entries(count: 0) }
      keyword_b = Fabricate(:parsed_keyword, user: user) { keyword_search_entries(count: 0) }
      Fabricate(:keyword_search_entry, urls: ['https://ruby-lang.org', 'https://ruby-doc.org'], keyword_id: keyword_a.id)
      Fabricate(:keyword_search_entry, urls: ['https://rubyapi.org'], keyword_id: keyword_b.id)

      sign_in(user)
      visit(root_path)
      within('form[data-testid="scrape-result-search-form"]') do
        fill_in('search', with: 'ruby')
        select(I18n.t('keywords.query_types.partial'), from: 'query_type')

        click_button I18n.t('shared.button.search')
      end

      page.assert_selector("[data-testid='search_result_search_term']", text: 'ruby', count: 1)
      page.assert_selector("[data-testid='search_result_query_type']", text: 'partial', count: 1)
      page.assert_selector("[data-testid='search_result_total_matched_urls']", text: '3', count: 1)

      within("div[data-keyword-id='#{keyword_a.id}']") do |item|
        item.assert_selector("[data-testid='search_result_keyword_content']", text: keyword_a.content, count: 1)
        item.assert_selector("ul[data-testid='search_result_url_list'] > li", count: 2)
        expect(item).to(have_link(href: keyword_path(keyword_a.id)))
      end

      within("div[data-keyword-id='#{keyword_b.id}']") do |item|
        item.assert_selector("[data-testid='search_result_keyword_content']", text: keyword_b.content, count: 1)
        item.assert_selector("ul[data-testid='search_result_url_list'] > li", count: 1)
        expect(item).to(have_link(href: keyword_path(keyword_b.id)))
      end
    end
    # rubocop:enable RSpec/ExampleLength
  end
end
