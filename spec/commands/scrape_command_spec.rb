# frozen_string_literal: true

require 'rails_helper'

SearchServiceError = GoogleScraperRuby::Errors::SearchServiceError

RSpec.describe ScrapeCommand, type: :service do
  describe '#run' do
    context 'given an existing keyword_id' do
      it 'updates the scrape result to the database if the command succeeds', vcr: 'google/google_no_ads' do
        keyword = Fabricate :keyword

        described_class.new(keyword_id: keyword.id).run
        updated = Keyword.includes(:keyword_search_entries).find(keyword.id)

        expect(updated.result_page_html).to be_a String
        expect(updated.links_count).to be_a Integer
        expect(updated.keyword_search_entries).not_to be_empty
      end

      it 'reraise the error and log an error message if an error occurs' do
        allow(Google::SearchService).to receive(:search!).and_raise(SearchServiceError, '')
        allow(Rails.logger).to receive(:error)
        keyword = Fabricate :keyword

        expect do
          described_class.new(keyword_id: keyword.id).run
        end.to raise_error(SearchServiceError)
        expect(Rails.logger).to have_received(:error).with(/error while processing command/)
      end
    end

    context 'given an non-existing keyword_id' do
      it 'raise ActiveRecord::RecordNotFound error and log an error message' do
        command = described_class.new(keyword_id: 42)
        allow(Rails.logger).to receive(:error)

        expect do
          command.run
        end.to raise_error(ActiveRecord::RecordNotFound)
        expect(Rails.logger).to have_received(:error).with(/keyword doesn't exist/)
      end
    end
  end
end
