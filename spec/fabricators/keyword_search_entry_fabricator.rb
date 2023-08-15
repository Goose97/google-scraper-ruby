# frozen_string_literal: true

Fabricator(:keyword_search_entry) do
  urls { Array.new(FFaker::Random.rand(1..10)) { FFaker::Internet.uri('https') } }
  kind { %i[ads non_ads].sample }
  position { %i[top bottom main_search].sample }
end
