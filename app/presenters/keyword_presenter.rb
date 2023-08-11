# frozen_string_literal: true

class KeywordPresenter
  attr_reader :keyword

  STATUS_BADGE = {
    'pending' => 'text-bg-light',
    'processing' => 'text-bg-primary',
    'succeeded' => 'text-bg-success',
    'failed' => 'text-bg-danger'
  }.freeze

  def initialize(keyword:)
    @keyword = keyword
  end

  def status_badge
    "badge #{STATUS_BADGE[keyword.status]}"
  end
end
