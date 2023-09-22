# frozen_string_literal: true

class KeywordSearchEntry < ApplicationRecord
  enum kind: { ads: 'ads', non_ads: 'non_ads' }
  enum position: { top: 'top', bottom: 'bottom', main_search: 'main_search' }

  belongs_to :keyword

  validates :kind, :position, :urls, presence: true

  scope :belongs_to_user, ->(user_id) { joins(:keyword).where(keywords: { user_id: user_id }) }
end
