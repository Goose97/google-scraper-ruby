# frozen_string_literal: true

module GoogleScraperRuby
  module Errors
    class SearchError < StandardError
      def initialize(url:, error: nil)
        @original_error = error
        @url = url
        super(error)
      end

      def to_s
        <<~ERR_MESSAGE
          Failed to perform search request with URL: #{url}
          - original_error: #{original_error}"
        ERR_MESSAGE
      end

      private

      attr_reader :original_error, :url
    end

    class ScrapeError < StandardError
      def initialize(keyword_id:, kind:, error: nil)
        @keyword_id = keyword_id
        @kind = kind
        @original_error = error
        super('')
      end

      def to_s
        <<~ERR_MESSAGE
          Failed to perform scrape request:
          - keyword_id: #{keyword_id}"
          - kind: #{kind}"
          - original_error: #{original_error}"
        ERR_MESSAGE
      end

      private

      attr_reader :keyword_id, :kind, :original_error
    end
  end
end
