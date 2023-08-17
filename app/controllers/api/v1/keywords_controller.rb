# frozen_string_literal: true

module Api
  module V1
    class KeywordsController < ApplicationController
      def index
        _, keywords = pagy(KeywordsQuery.new.call)

        render(json: ::V1::KeywordSerializer.new(keywords))
      end
    end
  end
end
