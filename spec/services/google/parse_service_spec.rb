# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Google::ParseService, type: :service do
  describe '#call' do
    it 'retrieves non-ads entries', vcr: 'google/ruby_11_non_ads' do
      html = Google::SearchService.new('ruby').search!

      non_ads = described_class.new(html).call.search_entries.count { |e| e.kind == :non_ads }

      expect(non_ads).to eq(11)
    end

    it 'extracts the non-ads entry URLs', vcr: 'google/ruby_11_non_ads' do
      html = Google::SearchService.new('ruby').search!

      entry = described_class.new(html).call.search_entries.find do |e|
        e.kind == :non_ads && e.urls.any? { |u| /ruby-lang.org/ =~ u }
      end

      expect(entry).not_to be_nil
    end

    it 'counts the number of links', vcr: 'google/monitor_50_links' do
      html = Google::SearchService.new('monitor').search!

      count = described_class.new(html).call.links_count

      expect(count).to eq(50)
    end

    it 'includes the html of such page', vcr: 'google/monitor_50_links' do
      html = Google::SearchService.new('monitor').search!

      result_page = described_class.new(html).call.result_page_html

      expect(result_page).to be_a String
    end

    context 'given a page with top and bottom ads' do
      it 'retrieves the top ads', vcr: 'google/programming_courses_3_top_1_bottom' do
        html = Google::SearchService.new('programming courses').search!

        top_ads = described_class.new(html).call.search_entries.count { |e| e.kind == :ads && e.position == :top }

        expect(top_ads).to eq(3)
      end

      it 'retrieves the bottom ads', vcr: 'google/programming_courses_3_top_1_bottom' do
        html = Google::SearchService.new('programming courses').search!

        bottom_ads = described_class.new(html).call.search_entries.count { |e| e.kind == :ads && e.position == :bottom }

        expect(bottom_ads).to eq(1)
      end

      it 'retrieves all the ads', vcr: 'google/programming_courses_3_top_1_bottom' do
        html = Google::SearchService.new('programming courses').search!

        ads = described_class.new(html).call.search_entries.count { |e| e.kind == :ads }

        expect(ads).to eq(4)
      end

      it 'extracts the ad entry URLs', vcr: 'google/iphone_store' do
        html = Google::SearchService.new('iphone store').search!

        entry = described_class.new(html).call.search_entries.find do |e|
          e.kind == :ads && e.urls.any? { |u| u.include?('www.apple.com') }
        end

        expect(entry).not_to be_nil
      end
    end

    context 'given a page WITHOUT any ads' do
      it 'counts 0 ads', vcr: 'google/google_no_ads' do
        html = Google::SearchService.new('google').search!

        ads = described_class.new(html).call.search_entries.count { |e| e.kind == :ads }

        expect(ads).to eq(0)
      end
    end
  end
end
