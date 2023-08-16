# frozen_string_literal: true

module Api
  module V1
    module ErrorHandlerConcern
      extend ActiveSupport::Concern

      private

      # Render Error Message in json_api format
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
