# frozen_string_literal: true

module Api
  module V1
    class ApplicationController < ActionController::API
      include(Localization)
      include(Pagy::Backend)

      rescue_from(Pagy::OverflowError) do |error|
        render_error(
          status: :unprocessable_entity,
          code: :invalid_page_number,
          detail: I18n.t('pagy.errors.overflow', max_page: error.pagy.last),
          source: error.class.name
        )
      end

      rescue_from(ActiveRecord::RecordNotFound) do |error|
        render_error(
          status: :not_found,
          code: :record_not_found,
          source: error.class.name
        )
      end

      private

      def render_error(status:, code:, detail: nil, source: nil)
        error = {
          source: source,
          detail: detail,
          code: code
        }.compact_blank

        render(json: { errors: [error] }, status: status)
      end
    end
  end
end
