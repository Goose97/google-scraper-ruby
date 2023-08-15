# frozen_string_literal: true

class ScrapeKeywordJob < ApplicationJob
  queue_as :default

  sidekiq_options retry: 0

  retry_on GoogleScraperRuby::Errors::ScrapeError, wait: 1.minute, attempts: 3 do |job, _error|
    keyword_id = job.arguments.first[:keyword_id]
    # TODO(Goose97): better handle database failure
    # If the below update crashes, the system ends up in an inconsistent state: the job still
    # has :processing status but already moved to Sidekiq dead queue
    keyword = Keyword.update(keyword_id, status: :failed)
    Google::ScrapeService.broadcast_status_update(keyword)
  end

  def perform(keyword_id:)
    Google::ScrapeService.new(keyword_id: keyword_id).call!
  rescue GoogleScraperRuby::Errors::ScrapeError => error
    raise(error) unless error.kind == :invalid_keyword
  end
end
