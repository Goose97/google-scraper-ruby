# frozen_string_literal: true

module Google
  class ScrapeService
    attr_reader :keyword

    def initialize(keyword_id:)
      @keyword_id = keyword_id
    end

    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize
    def call
      keyword = Keyword.find(@keyword_id)
      html = Google::SearchService.search!(keyword.content)
      result = Google::ParseService.new(html).call

      save_scrape_result keyword, result
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.error "[#{self.class.name}]: keyword doesn't exist
    - keyword_id: #{@keyword_id}"

      raise e
    rescue GoogleScraperRuby::Errors::SearchServiceError => e
      Rails.logger.error "[#{self.class.name}]: error while processing request
    - keyword: #{keyword.content}
    - error: #{e}"

      raise e
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize

    private

    def save_scrape_result(keyword, parse_result)
      Keyword.transaction do
        keyword.update!(
          links_count: parse_result.links_count,
          result_page_html: parse_result.result_page_html,
          status: :succeeded
        )

        # rubocop:disable Rails/SkipsModelValidations
        keyword.keyword_search_entries.insert_all parse_result.search_entries.map(&:to_h)
        # rubocop:enable Rails/SkipsModelValidations
      end
    end
  end
end
