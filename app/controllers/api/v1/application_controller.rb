# frozen_string_literal: true

module Api
  module V1
    class ApplicationController < ActionController::API
      include(Localization)
      include(Pagy::Backend)
      include(Api::V1::ErrorHandlerConcern)

      rescue_from(Pagy::OverflowError) do |error|
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
