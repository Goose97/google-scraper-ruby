# frozen_string_literal: true

class SearchResultPresenter
  attr_reader :search_result

  def initialize(search_result:)
    @search_result = search_result
  end

  def total_urls
    search_result.sum { |item| item[:urls].size }
  end
end
