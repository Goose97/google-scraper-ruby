# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(KeywordsQuery) do
  describe '#call' do
    context 'given NO keywords' do
      it 'returns an empty list' do
        keywords = described_class.new.call

        expect(keywords).to(be_empty)
      end
    end

    context 'given 5 keywords' do
      it 'returns 5 keywords' do
        Fabricate.times(5, :keyword)

        keywords = described_class.new.call

        expect(keywords.length).to(eq(5))
      end

      it 'returns keywords sorted by content in descending order' do
        Fabricate.times(5, :keyword)

        keywords = described_class.new.call

        sorted_keywords = keywords.sort_by { |k| k[:content] }
        expect(keywords).to(eq(sorted_keywords))
      end
    end
  end
end
