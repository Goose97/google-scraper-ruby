# frozen_string_literal: true

class KeywordSearchEntriesQuery
  def initialize(keyword_id:, relation: KeywordSearchEntry)
    relation = relation.where(keyword_id: keyword_id)
    @relation = relation
  end

  def top_ads_count
    top_ads.size
  end

  def total_ads_count
    relation.where(kind: :ads).size
  end

  def non_ads_count
    non_ads.size
  end

  def top_ads_urls
    urls_of(top_ads)
  end

  def non_ads_urls
    urls_of(non_ads)
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

  def top_ads
    @top_ads ||= relation.where(kind: :ads, position: :top)
  end

  def non_ads
    @non_ads ||= relation.where(kind: :non_ads)
  end
end
