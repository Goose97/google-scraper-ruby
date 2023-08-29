# frozen_string_literal: true

module V1
  class KeywordSerializer < V1::KeywordSimpleSerializer
    attributes :result_page_html, :links_count

    attributes :top_ads_count do |_, params|
      params[:search_entries_query].top_ads_count
    end

    attributes :total_ads_count do |_, params|
      params[:search_entries_query].total_ads_count
    end

    attributes :non_ads_count do |_, params|
      params[:search_entries_query].non_ads_count
    end

    attributes :top_ads_urls do |_, params|
      params[:search_entries_query].top_ads_urls
    end

    attributes :non_ads_urls do |_, params|
      params[:search_entries_query].non_ads_urls
    end
  end
end
