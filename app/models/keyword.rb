# frozen_string_literal: true

class Keyword < ApplicationRecord
  enum status: { processing: 'processing', succeeded: 'succeeded', failed: 'failed' }

  has_many :keyword_search_entries, dependent: :destroy

  validates :content, :status, presence: true
  validates :result_page_html, presence: true, if: :succeeded?
  validates :links_count,
            presence: true,
            numericality: { greater_than_or_equal_to: 0 },
            if: :succeeded?

  private

  def succeeded?
    status == 'succeeded'
  end
end
