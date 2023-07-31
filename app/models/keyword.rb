# frozen_string_literal: true

class Keyword < ApplicationRecord
  enum status: { processing: 'processing', succeeded: 'succeeded', failed: 'failed' }

  has_many :keyword_search_entries, dependent: :destroy

  validates :content, :status, presence: true
end
