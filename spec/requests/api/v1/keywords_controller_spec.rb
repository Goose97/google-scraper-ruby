# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(Api::V1::KeywordsController) do
  describe 'GET #index' do
    it 'returns the first page of keywords' do
      page_size = Pagy::DEFAULT[:items]
      Fabricate.times(page_size + 1, :keyword)

      get(api_v1_keywords_path)

      expect(json_response[:data].count).to(eq(page_size))
    end

    context 'given a VALID page params' do
      it 'returns a 200 status code' do
        page_size = Pagy::DEFAULT[:items]
        Fabricate.times(page_size, :keyword)

        get(api_v1_keywords_path, params: { page: 1 })

        expect(response).to(have_http_status(:success))
      end

      it 'returns a list of keywords' do
        Fabricate.times(2, :keyword)

        get(api_v1_keywords_path, params: { page: 1 })

        expect(response.parsed_body).to(match_json_schema('v1/keywords/list'))
      end
    end

    context 'given INVALID page params' do
      it 'returns a 422 status code' do
        page_size = Pagy::DEFAULT[:items]
        Fabricate.times(page_size, :keyword)

        get(api_v1_keywords_path, params: { page: 2 })

        expect(response).to(have_http_status(:unprocessable_entity))
      end
    end
  end

  describe 'GET #show' do
    context 'given a VALID keyword id' do
      it 'returns a 200 status code' do
        keyword = Fabricate(:parsed_keyword)

        get(api_v1_keyword_path(keyword))

        expect(response).to(have_http_status(:success))
      end

      it 'returns the keyword with detailed information' do
        keyword = Fabricate(:parsed_keyword)

        get(api_v1_keyword_path(keyword))

        expect(response.parsed_body).to(match_json_schema('v1/keywords/show'))
      end
    end

    context 'given INVALID keyword id' do
      it 'returns a 404 status code' do
        get(api_v1_keyword_path(id: 42))

        expect(response).to(have_http_status(:not_found))
      end
    end
  end

  describe 'GET #index/search' do
    context 'given VALID params' do
      it 'returns a 200 status code' do
        url = 'https://google.com'
        keyword = Fabricate(:parsed_keyword) { keyword_search_entries(count: 0) }
        Fabricate.times(2, :keyword_search_entry, urls: [url], keyword_id: keyword.id)
        Fabricate(:keyword_search_entry, urls: ['https://ruby-lang.org'], keyword_id: keyword.id)

        get(search_api_v1_keywords_path, params: { search: 'google', query_type: 'partial' })

        expect(response).to(have_http_status(:success))
      end

      it 'returns the search result' do
        url = 'https://google.com'
        keyword = Fabricate(:parsed_keyword) { keyword_search_entries(count: 0) }
        Fabricate.times(2, :keyword_search_entry, urls: [url], keyword_id: keyword.id)
        Fabricate(:keyword_search_entry, urls: ['https://ruby-lang.org'], keyword_id: keyword.id)

        get(search_api_v1_keywords_path, params: { search: 'google', query_type: 'partial' })

        expect(response.parsed_body).to(match_json_schema('v1/keywords/search'))
      end
    end

    context 'given INVALID params' do
      context 'given INVALID query_type' do
        it 'returns 422 status code' do
          get(search_api_v1_keywords_path, params: { search: 'google', query_type: 'invalid_query_type' })

          expect(response).to(have_http_status(:unprocessable_entity))
        end
      end
    end
  end
end
