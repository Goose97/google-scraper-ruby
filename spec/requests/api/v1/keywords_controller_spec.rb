# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(Api::V1::KeywordsController) do
  describe 'GET #index' do
    context 'given one page of keywords' do
      it 'returns all keywords' do
        page_size = Pagy::DEFAULT[:items]
        Fabricate.times(page_size, :keyword)

        get(api_v1_keywords_path)

        expect(json_response[:data].count).to(eq(page_size))
      end
    end

    context 'given more than one page of keywords' do
      it 'returns the first page of keywords' do
        page_size = Pagy::DEFAULT[:items]
        Fabricate.times(page_size + 1, :keyword)

        get(api_v1_keywords_path)

        expect(json_response[:data].count).to(eq(page_size))
      end
    end

    context 'given a VALID page params' do
      it 'returns a 200 status code' do
        page_size = Pagy::DEFAULT[:items]
        Fabricate.times(page_size, :keyword)

        get(api_v1_keywords_path, params: { page: 1 })

        expect(response).to(have_http_status(:success))
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
end