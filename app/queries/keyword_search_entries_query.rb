# frozen_string_literal: true

class KeywordSearchEntriesQuery
  def initialize(relation = KeywordSearchEntry)
    @relation = relation
  end

  def with_keyword(keyword_id)
    @relation = relation.where(keyword_id: keyword_id)

    self
  end

  def top_ads_count
    relation.where(kind: :ads, position: :top).size
  end

  def total_ads_count
    relation.where(kind: :ads).size
  end

  def non_ads_count
    relation.where(kind: :non_ads).size
  end

  def top_ads_urls
    urls_of(relation.where(kind: :ads, position: :top))
  end

  def non_ads_urls
    urls_of(relation.where(kind: :non_ads))
  end

  private

  attr_reader :relation

  def urls_of(query)
    query.pluck(:urls).flatten.uniq
  end
end
