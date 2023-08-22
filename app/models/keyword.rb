# frozen_string_literal: true

class Keyword < ApplicationRecord
  enum status: { pending: 'pending', processing: 'processing', succeeded: 'succeeded', failed: 'failed' }

  has_many :keyword_search_entries, dependent: :destroy
  has_one :keyword_stats, dependent: :nullify

  delegate :top_ads_urls, :non_ads_urls, to: :keyword_decorator
  delegate :top_ads_count, :total_ads_count, :non_ads_count, to: :keyword_stats, allow_nil: true

  validates :content, :status, presence: true
  validates :result_page_html, presence: true, if: :succeeded?
  validates :links_count,
            presence: true,
            numericality: { greater_than_or_equal_to: 0 },
            if: :succeeded?

  after_create_commit :enqueue_scrape_job

  private

  def keyword_decorator
    @keyword_decorator ||= KeywordDecorator.new(self)
  end

  def enqueue_scrape_job
    ScrapeKeywordJob.perform_later(keyword_id: id)
  end
end
