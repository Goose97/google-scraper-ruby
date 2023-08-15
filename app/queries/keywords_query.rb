# frozen_string_literal: true

class KeywordsQuery
  def call
    # TODO(Goose97): the details information about keywords will be implement
    # in view keyword details ticket (#21)
    Keyword.order(content: :asc)
  end
end
