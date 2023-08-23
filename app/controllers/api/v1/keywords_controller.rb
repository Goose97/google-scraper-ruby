# frozen_string_literal: true

module Api
  module V1
    class KeywordsController < ApplicationController
      def index
        _, keywords = pagy(KeywordsQuery.new.call)

        render(json: ::V1::KeywordSerializer.new(keywords))
      end

      def show
        keyword = Keyword.find(params['id'])
        search_entries_query = KeywordSearchEntriesQuery.new(keyword_id: keyword.id)

        render(json: ::V1::KeywordSerializer.new(keyword, params: {
                                                   action: :show,
                                                   search_entries_query: search_entries_query
                                                 }))
      end
    end
  end
end
