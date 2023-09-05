# frozen_string_literal: true

module V1
  class SearchResultSimpleSerializer < ApplicationSerializer
    set_id do
      'id'
    end

    attributes :keyword_id do |record|
      record['keyword_id']
    end

    attributes :urls do |record|
      record['urls']
    end

    belongs_to :keyword, lazy_load_data: true, links: {
      related: proc { |record| record[:keyword_url] }
    }
  end
end
