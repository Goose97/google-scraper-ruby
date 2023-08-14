# frozen_string_literal: true

require 'rails_helper'

describe 'View keywords list', type: :system do
  include ActiveJob::TestHelper

  context 'given NO keyword' do
    it 'displays a no-keyword notice and DO NOT displays the pagination nav' do
      visit(root_path)

      expect(page).to(have_selector('[data-testid="no-keyword-notice"]'))
      expect(page).not_to(have_selector('nav#keywords-table__pagination'))
    end
  end

  context 'given a list of keywords' do
    it 'displays a link to keywords#show for each keyword and displays the pagination nav' do
      Fabricate.times(2, :keyword)

      visit(root_path)

      within('tbody') do |tbody|
        tbody.all('tr').each do |row|
          keyword_id = row['data-keyword-id']
          expect(row).to(have_link('', href: keyword_path(keyword_id)))
        end
      end

      expect(page).to(have_selector('.keywords-table__pagination'))
    end

    it 'updates the UI after the keyword finish processing', vcr: 'google/google_no_ads' do
      keyword = Fabricate(:keyword)

      visit(root_path)
      perform_enqueued_jobs do
        ScrapeKeywordJob.perform_later(keyword_id: keyword.id)
      end

      within("tbody > tr[data-keyword-id=\"#{keyword.id}\"]") do |tr|
        expect(tr.find('td[data-testid="status"]')).to(have_content('Succeeded'))
      end
    end
  end
end
