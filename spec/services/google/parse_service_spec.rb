# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Google::ParseService, type: :service do
  describe '#call' do
    context 'when parsing a page having 3 top ads and 1 bottom ad' do
      it 'counts 3 top ads', vcr: 'google/programming_courses_3_top_1_bottom' do
        html = Google::SearchService.search!('programming courses')
        top_ads = described_class.new(html).call.search_entries.count { |e| e.kind == :ads && e.position == :top }
        expect(top_ads).to eq(3)
      end

      it 'counts 1 bottom ads', vcr: 'google/programming_courses_3_top_1_bottom' do
        html = Google::SearchService.search!('programming courses')
        bottom_ads = described_class.new(html).call.search_entries.count { |e| e.kind == :ads && e.position == :bottom }
        expect(bottom_ads).to eq(1)
      end

      it 'counts 4 ads in total', vcr: 'google/programming_courses_3_top_1_bottom' do
        html = Google::SearchService.search!('programming courses')
        bottom_ads = described_class.new(html).call.search_entries.count { |e| e.kind == :ads }
        expect(bottom_ads).to eq(4)
      end
    end

    context 'when parsing a page having no ads' do
      it 'counts 0 ads', vcr: 'google/google_no_ads' do
        html = Google::SearchService.search!('google')
        ads = described_class.new(html).call.search_entries.count { |e| e.kind == :ads }
        expect(ads).to eq(0)
      end
    end

    context 'when parsing a page contains an ad for apple.com/store' do
      it 'includes a search entry with www.apple.com URL', vcr: 'google/iphone_store' do
        html = Google::SearchService.search!('iphone store')
        entry = described_class.new(html).call.search_entries.find do |e|
          e.kind == :ads && e.urls.any? { |u| u.include?('www.apple.com') }
        end

        expect(entry).not_to be_nil
      end
    end

    context 'when parsing a page contains 11 non-ads entries' do
      it 'counts 11 non-ads entries', vcr: 'google/ruby_11_non_ads' do
        html = Google::SearchService.search!('ruby')
        non_ads = described_class.new(html).call.search_entries.count { |e| e.kind == :non_ads }
        expect(non_ads).to eq(11)
      end
    end

    context 'when parsing a page contains a non-ads entry for ruby-lang.org' do
      it 'includes a search entry with ruby-lang.org URL', vcr: 'google/ruby_11_non_ads' do
        html = Google::SearchService.search!('ruby')
        entry = described_class.new(html).call.search_entries.find do |e|
          e.kind == :non_ads && e.urls.any? { |u| /ruby-lang.org/ =~ u }
        end

        expect(entry).not_to be_nil
      end
    end

    context 'when parsing a page contains 50 links' do
      it 'counts 50 links', vcr: 'google/monitor_50_links' do
        html = Google::SearchService.search!('monitor')
        count = described_class.new(html).call.links_count
        expect(count).to eq(50)
      end
    end

    context 'when parsing any page' do
      it 'includes the html of such page', vcr: 'google/monitor_50_links' do
        html = Google::SearchService.search!('monitor')
        expect(described_class.new(html).call.result_page_html).to be_a String
      end
    end
  end
end
