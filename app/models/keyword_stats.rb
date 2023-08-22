# frozen_string_literal: true

class KeywordStats < ApplicationRecord
  belongs_to :keyword

  self.primary_key = :keyword_id

  def readonly?
    true
  end
end
