# frozen_string_literal: true

module GoogleScraperRuby
  module Errors
    class SearchServiceError < StandardError
      def initialize(url:, error: nil)
        @original_error = error
        @url = url
        super('')
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

      def initialize(url, error = nil)
        @original_error = error
        msg = "Failed to perform search request with URL: #{url}"
        super(msg)
      end

      def to_s = "#{super}\nOriginal error: #{@original_error}"
    end
  end
end
