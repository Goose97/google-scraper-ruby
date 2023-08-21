# frozen_string_literal: true

class KeywordDecorator < SimpleDelegator
  def top_ads_urls
    urls_of(keyword_search_entries.where(kind: :ads, position: :top))
  end

  def non_ads_urls
    urls_of(keyword_search_entries.where(kind: :non_ads))
  end

  private

  def urls_of(query)
    query.pluck(:urls).flatten.uniq
  end
end
