# frozen_string_literal: true

module V1
  class KeywordSerializer < ApplicationSerializer
    attributes :content, :status, :created_at, :updated_at

    attributes :result_page_html, :links_count, if: proc { |_, params| params[:action] == :show }

    attributes :search_entries_info, if: proc { |_, params| params[:action] == :show } do |_, params|
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
