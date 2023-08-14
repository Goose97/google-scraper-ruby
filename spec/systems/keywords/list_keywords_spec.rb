# frozen_string_literal: true

require 'rails_helper'

describe 'View keywords list', type: :system do
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

      expect(page).to(have_selector('nav#keywords-table__pagination'))
    end

    context 'given MORE than one page of keywords' do
      it 'displays one page of keywords' do
        Fabricate.times(Pagy::DEFAULT[:items] + 1, :keyword)

        visit(root_path)

        expect(page).to(have_selector('tbody > tr', count: Pagy::DEFAULT[:items]))
      end
    end

    context 'given LESS than one page of keywords' do
      it 'displays all keywords' do
        keywords_count = FFaker::Random.rand(1..Pagy::DEFAULT[:items])
        Fabricate.times(keywords_count, :keyword)

        visit(root_path)

        expect(page).to(have_selector('tbody > tr', count: keywords_count))
      end
    end
  end
end
