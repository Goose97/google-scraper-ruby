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

  def status
    I18n.t("keywords.status.#{keyword.status}")
  end

  def status_badge
    "badge #{STATUS_BADGE[keyword.status]}"
  end

  def upload_time
    keyword.created_at.strftime('%H:%M, %-d %B')
  end

  def show_detail_link?
    keyword.status == 'succeeded'
  end
end
