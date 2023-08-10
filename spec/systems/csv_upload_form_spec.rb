# frozen_string_literal: true

require 'rails_helper'

describe 'CSV upload form', type: :system do
  describe 'keywords#create' do
    context 'given a VALID file' do
      it 'redirects to keywords#index path and displays success alert' do
        upload_file('valid_7_keywords.csv')

        expect(page).to(have_current_path(keywords_path))

        error_message = I18n.t('activemodel.csv.upload_success')
        expect(find('[data-testid="alert-success"]')).to(have_content(error_message))
      end
    end

    context 'given an INVALID file' do
      context 'given too many keywords' do
        it 'displays an error alert' do
          upload_file('too_many_keywords.csv')

          error_message = I18n.t('activemodel.csv.errors.invalid_keyword_count')
          expect(find('[data-testid="alert-error"]')).to(have_content(error_message))
        end
      end
    end
  end
end
