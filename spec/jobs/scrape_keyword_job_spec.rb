# frozen_string_literal: true

require 'rails_helper'

describe ScrapeKeywordJob do
  include ActiveJob::TestHelper

  describe '#perform' do
    context 'given an ERROR occurs' do
      context "when the keyword doesn't exist" do
        it 'DOES NOT retry' do
          perform_enqueued_jobs do
            described_class.perform_later(keyword_id: 42)
          end

          assert_performed_jobs(1)
        end
      end

      context 'when an unexpected error occurs' do
        it 'retries at most 3 times' do
          keyword = Fabricate(:keyword)

          scrape_service = instance_double(Google::ScrapeService)
          allow(scrape_service).to(receive(:call!).and_raise(
                                     GoogleScraperRuby::Errors::ScrapeError.new(keyword_id: keyword.id, kind: :unexpected_error)
                                   ))
          allow(Google::ScrapeService).to(receive(:new).and_return(scrape_service))

          perform_enqueued_jobs { described_class.perform_later(keyword_id: keyword.id) }

          assert_performed_jobs(3)
        end

        context 'when the maximum retry times is exceeded' do
          it 'sets the keyword status as :failed' do
            keyword = Fabricate(:keyword)

            stub = Google::ScrapeService.new(keyword_id: keyword.id)
            allow(stub).to(receive(:call!).and_raise(
                             GoogleScraperRuby::Errors::ScrapeError.new(keyword_id: keyword.id, kind: :unexpected_error)
                           ))
            allow(Google::ScrapeService).to(receive(:new).and_return(stub))

            perform_enqueued_jobs { described_class.perform_later(keyword_id: keyword.id) }
            keyword.reload

            expect(keyword).to(be_failed)
          end
        end
      end
    end
  end
end
