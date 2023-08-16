# frozen_string_literal: true

class KeywordSerializer
  include JSONAPI::Serializer

  attributes :content, :status, :created_at, :updated_at
end
