# frozen_string_literal: true

require 'rails_helper'
require 'support/file_upload_helpers'

RSpec.describe('Keywords') do
  describe 'GET #index' do
    it 'returns the current user keywords' do
      user = Fabricate(:user)
      sign_in(user)
      keyword_a = Fabricate(:keyword, user: user)
      keyword_b = Fabricate(:keyword, user: user)
      _other_user_keyword = Fabricate(:keyword)

      get(keywords_path)

      assert_select('[data-testid="keyword_list_item"]') do |rows|
        expect(rows.count).to(eq(2))
        expect(rows.pluck('data-keyword-id')).to(contain_exactly(keyword_a.id.to_s, keyword_b.id.to_s))
      end
    end
  end

  describe 'POST #create' do
    it 'returns a 302 status code' do
      user = Fabricate(:user)
      sign_in(user)

      file = FileUploadHelpers::Form.upload_file(fixture: 'valid_7_keywords.csv')

      post(keywords_path, params: { csv_upload_form: { file: file } })

      expect(response).to(have_http_status(:found))
    end

    it 'redirects to keywords#index path' do
      user = Fabricate(:user)
      sign_in(user)

      file = FileUploadHelpers::Form.upload_file(fixture: 'valid_7_keywords.csv')

      post keywords_path, params: { csv_upload_form: { file: file } }

      expect(response).to(redirect_to(keywords_path))
    end

    context 'given a VALID file' do
      it 'includes a flash message in the response' do
        user = Fabricate(:user)
        sign_in(user)

        file = FileUploadHelpers::Form.upload_file(fixture: 'valid_7_keywords.csv')

        post(keywords_path, params: { csv_upload_form: { file: file } })

        expect(flash[:notice]).to(eq(I18n.t('activemodel.csv.upload_success')))
      end
    end

    context 'given an INVALID file' do
      it 'includes a flash message in the response' do
        user = Fabricate(:user)
        sign_in(user)

        file = FileUploadHelpers::Form.upload_file(fixture: 'too_many_keywords.csv')

        post(keywords_path, params: { csv_upload_form: { file: file } })

        error_message = include(I18n.t('activemodel.csv.errors.invalid_keyword_count'))
        expect(flash[:alert]).to(include(error_message))
      end
    end
  end

  describe 'GET #search' do
    context 'given VALID params' do
      it 'returns a 200 status code' do
        user = Fabricate(:user)
        sign_in(user)

        get(search_keywords_path, params: { search: 'abc', query_type: 'exact' })

        expect(response).to(have_http_status(:success))
      end
    end

    context 'given INVALID params' do
      context 'given an INVALID query_type' do
        it 'redirects to keywords#index path' do
          user = Fabricate(:user)
          sign_in(user)

          get(search_keywords_path, params: { search: 'abc', query_type: 'invalid_query_type' })

          expect(response).to(redirect_to(keywords_path))
        end

        it 'includes a flash message in the response' do
          user = Fabricate(:user)
          sign_in(user)

          get(search_keywords_path, params: { search: 'abc', query_type: 'invalid_query_type' })

          error_message = include(I18n.t('activemodel.errors.models.scrape_result_search_params.attributes.query_type.inclusion'))
          expect(flash[:alert]).to(include(error_message))
        end
      end
    end
  end
end
