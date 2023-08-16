# frozen_string_literal: true

Fabricator(:keyword) do
  content { FFaker::Lorem.characters(16) }
  status :processing
end

Fabricator(:parsed_keyword, from: :keyword) do
  content { FFaker::Lorem.characters(16) }
  status { :succeeded }
  result_page_html { FFaker::Lorem.paragraph(16) }
  links_count { FFaker::Random.rand(1..10) }
  keyword_search_entries(count: 2)
end
