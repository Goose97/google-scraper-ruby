# frozen_string_literal: true

require 'rails_helper'

describe 'View keyword details', type: :system do
  include ActiveJob::TestHelper

  it 'displays a link to keywords#show for succeeded keyword and displays the pagination nav' do
    keyword = Fabricate(:parsed_keyword)

    visit(keyword_path(keyword))

    expect(page).to(have_selector('p[data-testid="keyword_details_content"]'))
    expect(page).to(have_selector('p[data-testid="keyword_details_links_count"]'))
    expect(page).to(have_selector('p[data-testid="keyword_details_top_ads_count"]'))
    expect(page).to(have_selector('p[data-testid="keyword_details_total_ads_count"]'))
    expect(page).to(have_selector('p[data-testid="keyword_details_non_ads_count"]'))
    expect(page).to(have_selector('p[data-testid="keyword_details_ads_urls"]'))
    expect(page).to(have_selector('p[data-testid="keyword_details_non_ads_urls"]'))
    expect(page).to(have_selector('div[data-testid="keyword_details_page_view"]'))
  end
end
