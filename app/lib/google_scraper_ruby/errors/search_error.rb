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
  end
end
