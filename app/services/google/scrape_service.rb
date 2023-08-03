# frozen_string_literal: true

module Google
  class ScrapeService
    def initialize(keyword_id:, search_service: Google::SearchService.new, parse_service: Google::ParseService.new)
      @keyword_id = keyword_id
      @search_service = search_service
      @parse_service = parse_service
    end

    def call!
      # TODO(Goose97): update failed status once we integrate with background job
      keyword = Keyword.find_by id: keyword_id
      raise_keyword_not_found unless keyword
      @keyword = keyword

      begin
        html = search_service.search! keyword.content
      rescue GoogleScraperRuby::Errors::SearchServiceError => error
        raise_unexpected_error error
      end

      result = parse_service.call(html)

      save_scrape_result keyword, result
    end

    private

    attr_reader :keyword_id, :keyword, :search_service, :parse_service

    def raise_keyword_not_found
      Rails.logger.error <<~ERROR
        [#{self.class.name}]: keyword doesn't exist
        - keyword_id: #{keyword_id}
      ERROR

      raise GoogleScraperRuby::Errors::ScrapeServiceError.new(
        keyword_id: keyword_id,
        kind: :invalid_keyword
      )
    end

    def raise_unexpected_error(error)
      Rails.logger.error <<~ERROR
        [#{self.class.name}]: unexpected error while processing request
        - keyword: #{keyword.content}
        - error: #{error}
      ERROR

      raise GoogleScraperRuby::Errors::ScrapeServiceError.new(
        keyword_id: keyword_id,
        kind: :unexpected_error,
        error: error
      )
    end

    def save_scrape_result(keyword, parse_result)
      Keyword.transaction do
        keyword.update!(
          links_count: parse_result.links_count,
          result_page_html: parse_result.result_page_html,
          status: :succeeded
        )

        # rubocop:disable Rails/SkipsModelValidations
        keyword.keyword_search_entries.insert_all(parse_result.search_entries.map(&:to_h))
        # rubocop:enable Rails/SkipsModelValidations
      end
    end
  end
end
