# frozen_string_literal: true

require 'rails_helper'

SearchServiceError = GoogleScraperRuby::Errors::SearchServiceError

RSpec.describe Google::ScrapeService, type: :service do
  describe '#call' do
    context 'given an existing keyword_id' do
      context 'given NO errors' do
        it 'saves the html of the result page', vcr: 'google/google_no_ads' do
          keyword = Fabricate :keyword

          described_class.new(keyword_id: keyword.id).call
          updated = Keyword.includes(:keyword_search_entries).find(keyword.id)

          expect(updated.result_page_html).to be_a String
        end

        it 'saves the links count', vcr: 'google/google_no_ads' do
          keyword = Fabricate :keyword

          described_class.new(keyword_id: keyword.id).call
          updated = Keyword.includes(:keyword_search_entries).find(keyword.id)

          expect(updated.links_count).to be_a Integer
        end

        it 'saves all search entires', vcr: 'google/google_no_ads' do
          keyword = Fabricate :keyword

          described_class.new(keyword_id: keyword.id).call
          updated = Keyword.includes(:keyword_search_entries).find(keyword.id)

          expect(updated.keyword_search_entries).not_to be_empty
        end
      end

      context 'given errors' do
        it 'raises an error' do
          allow(Google::SearchService).to receive(:search!).and_raise(SearchServiceError, '')
          allow(Rails.logger).to receive(:error)

          expect do
            described_class.new(keyword_id: Fabricate(:keyword).id).call
          end.to raise_error(SearchServiceError)
        end

        it 'logs an error' do
          allow(Google::SearchService).to receive(:search!).and_raise(SearchServiceError, '')
          allow(Rails.logger).to receive(:error)

          begin
            described_class.new(keyword_id: Fabricate(:keyword).id).call
          rescue SearchServiceError
            expect(Rails.logger).to have_received(:error).with(/error while processing command/)
          end
        end
      end
    end

    context 'given an non-existing keyword_id' do
      it 'raise ActiveRecord::RecordNotFound error' do
        command = described_class.new(keyword_id: 42)
        allow(Rails.logger).to receive(:error)

        expect do
          command.call
        end.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'logs an error' do
        command = described_class.new(keyword_id: 42)
        allow(Rails.logger).to receive(:error)

        begin
          command.call
        rescue ActiveRecord::RecordNotFound
          expect(Rails.logger).to have_received(:error).with(/keyword doesn't exist/)
        end
      end
    end
  end
end
