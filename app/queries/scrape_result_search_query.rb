# frozen_string_literal: true

class ScrapeResultSearchQuery
  def initialize(pattern:, query_type:)
    params = ScrapeResultSearchParams.new(pattern: pattern, query_type: query_type)
    params.validate!

    @pattern = params.pattern
    @query_type = params.query_type
  end

  def call
    all_search_entries
      .group_by(&:keyword_id)
      .filter_map do |keyword_id, search_entries|
        matched_urls = search_entries.flat_map(&:urls).filter { |url| url_match?(url) }
        { keyword_id: keyword_id, urls: matched_urls } unless matched_urls.empty?
      end
  end

  private

  attr_reader :query_type, :pattern

  def all_search_entries
    @all_search_entries ||= KeywordSearchEntry.all
  end

  def url_match?(url)
    case query_type
    when :exact
      url == pattern
    when :partial
      url.include?(pattern)
    # TODO(Goose97): allowing users to execute abitrary regexes is quite dangerous
    # A carefully crafted regex can cause catastrophic backtracking (https://www.regular-expressions.info/catastrophic.html)
    # We should try to restrict it
    when :pattern
      url =~ Regexp.new(pattern)
    end
  end
end
