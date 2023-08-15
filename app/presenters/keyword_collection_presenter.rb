# frozen_string_literal: true

class KeywordCollectionPresenter
  def initialize(keywords:)
    @keywords = keywords
  end

  def keywords
    @keywords.map { |keyword| KeywordPresenter.new(keyword: keyword) }
  end

  def empty?
    @keywords.empty?
  end
end
