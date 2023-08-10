# frozen_string_literal: true

class KeywordsQuery
  def initialize(filters = {})
    # NOTE(Goose97): we don't support any filters for now
    @filters = filters
  end

  def call
    # NOTE(Goose97): the details information about keywords will be implement
    # in view keyword details ticket (#21)
    Keyword.order(content: :asc)
  end
end
