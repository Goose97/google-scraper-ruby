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

  def initialize(pattern:, query_type:)
    params = ScrapeResultSearchParams.new(pattern: pattern, query_type: query_type)
    params.validate!

    @pattern = params.pattern
    @query_type = params.query_type
  end

  def call
    sub_query = KeywordSearchEntry.select(:keyword_id, 'unnest(urls) url').to_sql

    KeywordSearchEntry.select(:keyword_id, 'array_agg(url) urls')
                      .from("(#{sub_query}) as unnest")
                      .where([URL_PREDICATE[query_type], pattern])
                      .group(:keyword_id)
                      .map { |item| item.slice(:keyword_id, :urls) }
  end

  private

  attr_reader :query_type, :pattern
end
