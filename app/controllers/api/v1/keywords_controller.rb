# frozen_string_literal: true

module Api
  module V1
    class KeywordsController < ApplicationController
      include ErrorHandlerConcern

      def index
        _, keywords = pagy(KeywordsQuery.new.call)

        render(json: KeywordSerializer.new(keywords))
      rescue Pagy::OverflowError => error
        render_error(
          status: :unprocessable_entity,
          code: :invalid_page_number,
          detail: I18n.t('pagy.errors.overflow', max_page: error.pagy.last),
          source: error.class.name
        )
      end
    end
  end
end
