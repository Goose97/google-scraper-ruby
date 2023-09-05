# frozen_string_literal: true

module Google
  class ScrapeService
    def initialize(keyword_id:, search_service: Google::SearchService.new, parse_service: Google::ParseService.new)
      @keyword_id = keyword_id
      @search_service = search_service
      @parse_service = parse_service
    end

    def call!
      begin
        @keyword = Keyword.find(keyword_id)
        keyword.update(status: :processing)
      rescue ActiveRecord::RecordNotFound
        raise_keyword_not_found
      end

      result = parse_service.call(result_page!)
      save_scrape_result!(keyword, result)
    end

    private

    attr_reader :keyword_id, :keyword, :search_service, :parse_service

    def result_page!
      search_service.search!(keyword.content)
    rescue GoogleScraperRuby::Errors::SearchError => error
      raise_scrape_error(error)
    end

    def raise_keyword_not_found
      Rails.logger.error(
        <<~ERROR
          [#{self.class.name}]: keyword doesn't exist
          - keyword_id: #{keyword_id}
        ERROR
      )

      raise(GoogleScraperRuby::Errors::ScrapeError.new(
              keyword_id: keyword_id,
              kind: :invalid_keyword
            ))
    end

    # rubocop:disable Metrics/MethodLength
    def raise_scrape_error(error)
      Rails.logger.error(
        <<~ERROR
          [#{self.class.name}]: unexpected error while processing request
          - keyword: #{keyword.content}
          - error: #{error}
        ERROR
      )

      raise(GoogleScraperRuby::Errors::ScrapeError.new(
              keyword_id: keyword_id,
              kind: :search_error,
              error: error
            ))
    end
    # rubocop:enable Metrics/MethodLength

    def save_scrape_result!(keyword, parse_result)
      keyword.update!(
        links_count: parse_result.links_count,
        result_page_html: parse_result.result_page_html,
        status: :succeeded,
        keyword_search_entries: parse_result.search_entries
      )
    end
  end
end
