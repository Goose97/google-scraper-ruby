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

  private

  attr_reader :relation
end
