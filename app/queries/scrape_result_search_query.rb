# frozen_string_literal: true

class ScrapeResultSearchQuery
  def initialize(pattern:, query_type:)
    @pattern = pattern
    @query_type = query_type
  end

  def call
    all_search_entries.filter_map do |entry|
      matched_urls = entry.urls.filter { |url| url_match?(url) }
      { keyword_id: entry.keyword_id, urls: matched_urls } unless matched_urls.empty?
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
