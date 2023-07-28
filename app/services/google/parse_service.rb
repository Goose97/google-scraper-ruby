# frozen_string_literal: true

module Google
  class ParseService
    Result = Struct.new(:search_entries, :links_count, :result_page_html)
    SearchEntry = Struct.new(:kind, :urls, :position)

    def initialize(html)
      @html = html
      @doc = Nokogiri::HTML(html)
    end

    def call
      Result.new(
        search_entries: [*top_ads, *bottom_ads, *non_ads_normal, *non_ads_video],
        links_count: @doc.css('a[href]').count,
        result_page_html: @html
      )
    end

    private

    def top_ads
      @doc.css('#taw div[data-text-ad]').map do |ad_div|
        SearchEntry.new(
          kind: :ads,
          urls: extract_links(ad_div),
          position: :top
        )
      end
    end

    def bottom_ads
      @doc.css('#bottomads div[data-text-ad]').map do |ad_div|
        SearchEntry.new(
          kind: :ads,
          urls: extract_links(ad_div),
          position: :bottom
        )
      end
    end

    def non_ads_normal
      @doc.css('#search div[data-snhf]').map do |div|
        SearchEntry.new(
          kind: :non_ads,
          urls: extract_links(div),
          position: nil
        )
      end
    end

    def non_ads_video
      @doc.css('#search div[data-vurl][jsaction]').map do |div|
        SearchEntry.new(
          kind: :non_ads,
          urls: extract_links(div),
          position: nil
        )
      end
    end

    def extract_links(doc) = doc.css('a[href][data-ved]').pluck(:href)
  end
end
