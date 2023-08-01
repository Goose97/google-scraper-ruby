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
        links_count: doc.css(GENERAL_LINKS_SELECTOR).count,
        result_page_html: html
      )
    end

    private

    TOP_ADS_SELECTOR = '#taw div[data-text-ad]'
    BOTTOM_ADS_SELECTOR = '#bottomads div[data-text-ad]'
    NON_ADS_NORMAL_SELECTOR = '#search div[data-snhf]'
    NON_ADS_VIDEO_SELECTOR = '#search div[data-vurl][jsaction]'
    GENERAL_LINKS_SELECTOR = 'a[href]'
    INSIDE_SEARCH_ENTRY_LINKS_SELECTOR = 'a[href][data-ved]'

    private_constant :TOP_ADS_SELECTOR, :BOTTOM_ADS_SELECTOR, :NON_ADS_NORMAL_SELECTOR, :NON_ADS_VIDEO_SELECTOR,
                     :GENERAL_LINKS_SELECTOR, :INSIDE_SEARCH_ENTRY_LINKS_SELECTOR

    attr_reader :doc, :html

    def top_ads
      doc.css(TOP_ADS_SELECTOR).map do |ad_div|
        SearchEntry.new(
          kind: :ads,
          urls: extract_links(ad_div),
          position: :top
        )
      end
    end

    def bottom_ads
      doc.css(BOTTOM_ADS_SELECTOR).map do |ad_div|
        SearchEntry.new(
          kind: :ads,
          urls: extract_links(ad_div),
          position: :bottom
        )
      end
    end

    def non_ads_normal
      doc.css(NON_ADS_NORMAL_SELECTOR).map do |div|
        SearchEntry.new(
          kind: :non_ads,
          urls: extract_links(div),
          position: nil
        )
      end
    end

    def non_ads_video
      doc.css(NON_ADS_VIDEO_SELECTOR).map do |div|
        SearchEntry.new(
          kind: :non_ads,
          urls: extract_links(div),
          position: nil
        )
      end
    end

    def extract_links(doc)
      doc.css(INSIDE_SEARCH_ENTRY_LINKS_SELECTOR).pluck(:href)
    end
  end
end
