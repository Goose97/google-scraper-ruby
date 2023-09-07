# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(ScrapeResultSearchQuery) do
  describe '#new' do
    context 'given valid params' do
      it 'does NOT raise errors' do
        expect { described_class.new(query_type: :pattern, pattern: 'abc') }
          .not_to(raise_error)
      end
    end

    context 'given INVALID params' do
      context 'given EMPTY pattern' do
        it 'raises ActiveModel::ValidationError' do
          expect { described_class.new(query_type: :pattern, pattern: '') }
            .to(raise_error do |error|
              expect(error).to(be_a(ActiveModel::ValidationError))
              expect(error.model.errors).to(include(:pattern))
            end)
        end
      end

      context 'given INVALID query_type' do
        it 'raises ActiveModel::ValidationError' do
          expect { described_class.new(query_type: :invalid, pattern: 'abc') }
            .to(raise_error do |error|
              expect(error).to(be_a(ActiveModel::ValidationError))
              expect(error.model.errors).to(include(:query_type))
            end)
        end
      end
    end
  end

  describe '#call' do
    context 'given :exact query type' do
      it 'returns all URLs satisfy the query pattern grouped by their keyword_id' do
        url = 'https://google.com'
        keyword = Fabricate(:parsed_keyword) { keyword_search_entries(count: 0) }
        Fabricate.times(2, :keyword_search_entry, urls: [url], keyword_id: keyword.id)
        Fabricate(:keyword_search_entry, urls: ['https://ruby-lang.org'], keyword_id: keyword.id)

        result = described_class.new(query_type: :exact, pattern: url).call

        expect(result).to(contain_exactly({
                                            keyword_id: keyword.id,
                                            keyword_content: keyword.content,
                                            urls: [url, url]
                                          }))
      end
    end

    context 'given :partial query type' do
      # rubocop:disable RSpec/ExampleLength
      it 'returns all URLs satisfy the query pattern grouped by their keyword_id' do
        url_a = 'https://google.com'
        url_b = 'https://www.google.com'
        keyword = Fabricate(:parsed_keyword) { keyword_search_entries(count: 0) }
        Fabricate(:keyword_search_entry, urls: [url_a], keyword_id: keyword.id)
        Fabricate(:keyword_search_entry, urls: [url_b], keyword_id: keyword.id)
        Fabricate(:keyword_search_entry, urls: ['https://ruby-lang.org'], keyword_id: keyword.id)

        result = described_class.new(query_type: :partial, pattern: 'google').call

        expect(result).to(contain_exactly({
                                            keyword_id: keyword.id,
                                            keyword_content: keyword.content,
                                            urls: [url_a, url_b]
                                          }))
      end
      # rubocop:enable RSpec/ExampleLength
    end

    context 'given :pattern query type' do
      # rubocop:disable RSpec/ExampleLength
      it 'returns all URLs satisfy the query pattern grouped by their keyword_id' do
        url_a = 'https://google.com'
        url_b = 'https://www.google.com'
        keyword = Fabricate(:parsed_keyword) { keyword_search_entries(count: 0) }
        Fabricate(:keyword_search_entry, urls: [url_a], keyword_id: keyword.id)
        Fabricate(:keyword_search_entry, urls: [url_b], keyword_id: keyword.id)
        Fabricate(:keyword_search_entry, urls: ['https://ruby-lang.org'], keyword_id: keyword.id)

        result = described_class.new(query_type: :pattern, pattern: 'go{2}\w+\.com$').call

        expect(result).to(contain_exactly({
                                            keyword_id: keyword.id,
                                            keyword_content: keyword.content,
                                            urls: [url_a, url_b]
                                          }))
      end
      # rubocop:enable RSpec/ExampleLength
    end
  end
end
