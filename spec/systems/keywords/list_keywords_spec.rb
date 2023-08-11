# frozen_string_literal: true

require 'rails_helper'

describe 'View keywords list', type: :system do
  context 'given NO keyword' do
    it 'displays a no-keyword notice and DO NOT displays the pagination nav' do
      Keyword.delete_all

      visit(root_path)

      expect(page).to(have_selector('[data-testid="no-keyword-notice"]'))
      expect(page).not_to(have_selector('nav#keywords-table__pagination'))
    end
  end

  context 'given SOME keywords' do
    it 'displays the pagination nav' do
      Fabricate.times(FFaker::Random.rand(1..100), :keyword)

      visit(root_path)

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
