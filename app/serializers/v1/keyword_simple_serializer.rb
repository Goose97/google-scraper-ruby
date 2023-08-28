# frozen_string_literal: true

module V1
  class KeywordSimpleSerializer < ApplicationSerializer
    attributes :content, :status, :created_at, :updated_at
  end
end
