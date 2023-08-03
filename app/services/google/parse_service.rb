# frozen_string_literal: true

module Google
  class ParseService
    ResultStruct = Struct.new(:search_entries, :links_count, :result_page_html)
    SearchEntryStruct = Struct.new(:kind, :urls, :position)

    def call(html)
      @html = html
      @doc = Nokogiri::HTML(html)

      ResultStruct.new(
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
        SearchEntryStruct.new(
          kind: :ads,
          urls: extract_links(ad_div),
          position: :top
        )
      end
    end

    def bottom_ads
      doc.css(BOTTOM_ADS_SELECTOR).map do |ad_div|
        SearchEntryStruct.new(
          kind: :ads,
          urls: extract_links(ad_div),
          position: :bottom
        )
      end
    end

    def non_ads_normal
      doc.css(NON_ADS_NORMAL_SELECTOR).map do |div|
        SearchEntryStruct.new(
          kind: :non_ads,
          urls: extract_links(div),
          position: :main_search
        )
      end
    end

    def non_ads_video
      doc.css(NON_ADS_VIDEO_SELECTOR).map do |div|
        SearchEntryStruct.new(
          kind: :non_ads,
          urls: extract_links(div),
          position: :main_search
        )
      end
    end

    def extract_links(doc)
      doc.css(INSIDE_SEARCH_ENTRY_LINKS_SELECTOR).pluck(:href)
    end
  end
end
