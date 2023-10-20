# frozen_string_literal: true

require 'rails_helper'

describe 'View keyword list', type: :system do
  include ActiveJob::TestHelper

  context 'given NO keyword' do
    it 'displays a no-keyword notice and DO NOT displays the pagination nav' do
      user = Fabricate(:user)
      sign_in(user)
      visit(root_path)

      expect(page).to(have_selector('[data-testid="no-keyword-notice"]'))
      expect(page).not_to(have_selector('nav#keywords-table__pagination'))
    end
  end

  context 'given a list of keywords' do
    it 'displays a link to keywords#show for succeeded keyword and displays the pagination nav' do
      user = Fabricate(:user)
      pending_keyword = Fabricate(:keyword)
      succeeded_keyword = Fabricate(:parsed_keyword)

      sign_in(user)
      visit(root_path)

      within('tbody') do |tbody|
        pending_row = tbody.find("tr[data-keyword-id=\"#{pending_keyword.id}\"]")
        expect(pending_row).not_to(have_link('', href: keyword_path(pending_keyword.id)))

        succeeded_row = tbody.find("tr[data-keyword-id=\"#{succeeded_keyword.id}\"]")
        expect(succeeded_row).to(have_link('', href: keyword_path(succeeded_keyword.id)))
      end

      expect(page).to(have_selector('.keywords-table__pagination'))
    end

    it 'updates the UI after the keyword finish processing', vcr: 'google/google_no_ads' do
      user = Fabricate(:user)
      keyword = Fabricate(:keyword)

      sign_in(user)
      visit(root_path)
      perform_enqueued_jobs do
        ScrapeKeywordJob.perform_later(keyword_id: keyword.id)
      end

      within("tbody > tr[data-keyword-id=\"#{keyword.id}\"]") do |tr|
        expect(tr.find('td[data-testid="status"]')).to(have_content(I18n.t('keywords.status.succeeded')))
      end
    end
  end
end
