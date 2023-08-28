# frozen_string_literal: true

module V1
  class KeywordSerializer < V1::KeywordSimpleSerializer
    attributes :result_page_html, :links_count

    attributes :search_entries_info do |_, params|
      {
        top_ads_count: params[:search_entries_query].top_ads_count,
        total_ads_count: params[:search_entries_query].total_ads_count,
        non_ads_count: params[:search_entries_query].non_ads_count,
        top_ads_urls: params[:search_entries_query].top_ads_urls,
        non_ads_urls: params[:search_entries_query].non_ads_urls
      }
    end
  end
end
