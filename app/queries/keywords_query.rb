# frozen_string_literal: true

class KeywordsQuery
  def initialize(scope: Keyword)
    @scope = scope
  end

  def call
    scope.order(content: :asc)
  end

  private

  attr_reader :scope
end
