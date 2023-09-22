# frozen_string_literal: true

class ScrapeResultSearchQuery
  URL_PREDICATE = {
    exact: 'url = ?',
    partial: "url LIKE '%' || ? || '%' ",
    # TODO(Goose97): allowing users to execute abitrary regexes is quite dangerous
    # A carefully crafted regex can cause catastrophic backtracking (https://www.regular-expressions.info/catastrophic.html)
    # We should try to restrict it
    pattern: 'url ~ ?'
  }.freeze

  def initialize(pattern:, query_type:, scope: KeywordSearchEntry)
    params = ScrapeResultSearchParams.new(pattern: pattern, query_type: query_type)
    params.validate!

    @scope = scope
    @pattern = params.pattern
    @query_type = params.query_type
  end

  def call
    search_entries_filtered_by_url
      .group(:keyword_id)
      .includes(:keyword)
      .map do |item|
      {
        keyword_id: item.keyword_id,
        keyword_content: item.keyword.content,
        urls: item.urls
      }
    end
  end

  private

  attr_reader :scope, :query_type, :pattern

  def search_entries_filtered_by_url
    sub_query = scope.select(:keyword_id, 'unnest(urls) url').to_sql

    KeywordSearchEntry.select(:keyword_id, 'array_agg(url) urls')
                      .from("(#{sub_query}) as unnest")
                      .where([URL_PREDICATE[query_type], pattern])
  end
end
