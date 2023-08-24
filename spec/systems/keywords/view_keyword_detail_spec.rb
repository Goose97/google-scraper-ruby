# frozen_string_literal: true

require 'rails_helper'

describe 'View keyword details', type: :system do
  # rubocop:disable RSpec/ExampleLength
  it 'displays the scraped content information' do
    mocked_html = '<div>Hello world</div>'
    keyword = Fabricate(:parsed_keyword) do
      links_count(12)
      result_page_html(mocked_html)
      keyword_search_entries(count: 0)
    end

    Fabricate.times(2, :keyword_search_entry, kind: :ads, position: :top, keyword_id: keyword.id) do
      urls([FFaker::Internet.uri('https')])
    end
    Fabricate.times(2, :keyword_search_entry, kind: :ads, position: :bottom, keyword_id: keyword.id)
    Fabricate.times(2, :keyword_search_entry, kind: :non_ads, keyword_id: keyword.id) do
      urls([FFaker::Internet.uri('https')])
    end

    visit(keyword_path(keyword))

    page.assert_selector('p[data-testid="keyword_details_content"]', count: 1, text: keyword.content)
    page.assert_selector('p[data-testid="keyword_details_links_count"]', count: 1, text: '12')
    page.assert_selector('p[data-testid="keyword_details_top_ads_count"]', count: 1, text: '2')
    page.assert_selector('p[data-testid="keyword_details_total_ads_count"]', count: 1, text: '4')
    page.assert_selector('p[data-testid="keyword_details_non_ads_count"]', count: 1, text: '2')

    page.assert_selector('div[data-testid="keyword_details_top_ads_urls"]', count: 1) do |element|
      element.assert_selector('[data-testid="keyword_details_url"]', count: 2)
    end

    page.assert_selector('div[data-testid="keyword_details_non_ads_urls"]', count: 1) do |element|
      element.assert_selector('[data-testid="keyword_details_url"]', count: 2)
    end

    page.find('div[data-testid="keyword_details_page_view"]').assert_selector('iframe') do |iframe|
      expect(iframe['srcdoc']).to(eq(mocked_html))
    end

    expect(page).to(have_link(I18n.t('keywords.shared.link.back_to_home'), href: keywords_path))
  end
  # rubocop:enable RSpec/ExampleLength
end
