# frozen_string_literal: true

module V1
  class KeywordSerializer < ApplicationSerializer
    attributes :content, :status, :created_at, :updated_at
  end
end
