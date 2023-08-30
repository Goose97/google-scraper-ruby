# frozen_string_literal: true

class ScrapeResultSearchParams
  include ActiveModel::Model

  attr_accessor :pattern, :query_type

  validates :pattern, :query_type, presence: true
  validates :query_type, inclusion: { in: %i[exact partial pattern] }
end
