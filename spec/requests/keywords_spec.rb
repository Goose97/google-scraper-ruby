# frozen_string_literal: true

require 'rails_helper'
require 'support/file_upload_helpers'

RSpec.describe('Keywords') do
  describe 'POST #create' do
    it 'returns a 302 status code' do
      file = FileUploadHelpers::Form.upload_file(fixture: 'valid_7_keywords.csv')

      post keywords_path, params: { csv_upload_form: { file: file } }

      expect(response).to(have_http_status(:found))
    end

    it 'redirects to keywords#index path' do
      file = FileUploadHelpers::Form.upload_file(fixture: 'valid_7_keywords.csv')

      post keywords_path, params: { csv_upload_form: { file: file } }

      expect(response).to(redirect_to(keywords_path))
    end

    context 'given a VALID file' do
      it 'includes a flash message in the response' do
        file = FileUploadHelpers::Form.upload_file(fixture: 'valid_7_keywords.csv')

        post keywords_path, params: { csv_upload_form: { file: file } }

        expect(flash[:notice]).to(eq(I18n.t('csv.upload_success')))
      end
    end

    context 'given an INVALID file' do
      it 'includes a flash message in the response' do
        file = FileUploadHelpers::Form.upload_file(fixture: 'too_many_keywords.csv')

        post keywords_path, params: { csv_upload_form: { file: file } }

        expect(flash[:alert]).not_to(be_nil)
      end
    end
  end
end
