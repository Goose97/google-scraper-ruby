# frozen_string_literal: true

Fabricator(:keyword) do
  content FFaker::Lorem.characters(16)
  status :processing
end
