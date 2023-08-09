# frozen_string_literal: true

require 'rails_helper'

describe 'CSV upload form', type: :system do
  describe 'keywords#index' do
    context 'when user reaches keywords page' do
      it 'displays the file upload form' do
        visit root_path

        expect(page).to(have_field('csv_upload_form[file]', visible: :hidden))
        expect(find("span[role='button']")).to(have_content(I18n.t('keywords.upload')))
      end
    end
  end

  describe 'keywords#create' do
    context 'given a VALID file' do
      it 'redirects to keywords#index path' do
        upload_file('valid_7_keywords.csv')

        expect(page).to(have_current_path(keywords_path))
      end

      it 'displays success alert' do
        upload_file('valid_7_keywords.csv')

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

      context 'given a file with incorrect content type' do
        it 'displays an error alert' do
          upload_file('wrong_type.txt')

          error_message = I18n.t('activemodel.csv.errors.invalid_file_type')
          expect(find('[data-testid="alert-error"]')).to(have_content(error_message))
        end
      end

      context 'given an empty file' do
        it 'displays an error alert' do
          upload_file('blank_file.csv')

          error_message = I18n.t('activemodel.csv.errors.invalid_keyword_count')
          expect(find('[data-testid="alert-error"]')).to(have_content(error_message))
        end
      end

      context 'given a keyword that has more than 255 characters' do
        it 'displays an error alert' do
          upload_file('too_long_keywords.csv')

          error_message = I18n.t('activemodel.csv.errors.invalid_keyword_length')
          expect(find('[data-testid="alert-error"]')).to(have_content(error_message))
        end
      end
    end
  end
end
