# frozen_string_literal: true

module Api
  module V1
    class KeywordsController < ApplicationController
      def index
        _, keywords = pagy(KeywordsQuery.new.call)

        render(json: ::V1::KeywordSimpleSerializer.new(keywords, is_collection: true))
      end

      def show
        keyword = Keyword.find(params[:id])
        search_entries_query = KeywordSearchEntriesQuery.new(keyword_id: keyword.id)

        render(json: ::V1::KeywordSerializer.new(keyword, params: {
                                                   search_entries_query: search_entries_query
                                                 }))
      end

      def search
        result = ScrapeResultSearchQuery.new(
          pattern: search_params[:search],
          query_type: search_params[:query_type]
        ).call

        render(json: ::V1::SearchResultSimpleSerializer.new(result, is_collection: true))
      end

      def search_params
        {
          search: params.require(:search),
          query_type: params.require(:query_type).to_sym
        }
      end
    end
  end
end
