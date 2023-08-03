# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Google::ScrapeService, type: :service do
  describe '#call!' do
    context 'given a VALID keyword_id' do
      context 'given NO errors' do
        it 'saves the html of the result page', vcr: 'google/google_no_ads' do
          keyword = Fabricate :keyword

          described_class.new(keyword_id: keyword.id).call!
          updated_keyword = keyword.reload

          expect(updated_keyword.result_page_html).to be_a String
        end

        it 'saves the links count', vcr: 'google/google_no_ads' do
          keyword = Fabricate :keyword

          described_class.new(keyword_id: keyword.id).call!
          updated_keyword = keyword.reload

          expect(updated_keyword.links_count).to be_a Integer
        end

        it 'saves all search entires', vcr: 'google/google_no_ads' do
          keyword = Fabricate :keyword

          described_class.new(keyword_id: keyword.id).call!
          updated_keyword = keyword.reload

          expect(updated_keyword.keyword_search_entries).not_to be_empty
        end

        it 'updates keyword status to succeeded', vcr: 'google/google_no_ads' do
          keyword = Fabricate :keyword

          described_class.new(keyword_id: keyword.id).call!
          updated_keyword = keyword.reload

          expect(updated_keyword.status).to eq('succeeded')
        end
      end

      context 'given errors' do
        it 'raises an error' do
          search_service = Google::SearchService.new
          allow(search_service).to receive(:search!).and_raise(GoogleScraperRuby::Errors::SearchServiceError.new(url: ''))
          allow(Rails.logger).to receive(:error)

          expect do
            described_class.new(
              keyword_id: Fabricate(:keyword).id,
              search_service: search_service
            ).call!
          end.to raise_error GoogleScraperRuby::Errors::ScrapeServiceError
        end

        # rubocop:disable Rspec/ExampleLength
        it 'logs an error' do
          search_service = Google::SearchService.new
          allow(search_service).to receive(:search!).and_raise(GoogleScraperRuby::Errors::SearchServiceError.new(url: ''))
          allow(Rails.logger).to receive(:error)

          begin
            described_class.new(
              keyword_id: Fabricate(:keyword).id,
              search_service: search_service
            ).call!
          rescue GoogleScraperRuby::Errors::ScrapeServiceError
            expect(Rails.logger).to have_received(:error).with(/unexpected error while processing request/)
          end
        end
        # rubocop:enable Rspec/ExampleLength
      end
    end

    context 'given an INVALID keyword_id' do
      it 'raises an error' do
        allow(Rails.logger).to receive(:error)

        expect do
          described_class.new(keyword_id: 42).call!
        end.to raise_error(GoogleScraperRuby::Errors::ScrapeServiceError)
      end

      it 'logs an error' do
        allow(Rails.logger).to receive(:error)

        begin
          described_class.new(keyword_id: 42).call!
        rescue GoogleScraperRuby::Errors::ScrapeServiceError
          expect(Rails.logger).to have_received(:error).with(/keyword doesn't exist/)
        end
      end
    end
  end
end
