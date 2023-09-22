# frozen_string_literal: true

require 'rails_helper'

describe(KeywordSearchEntry) do
  describe '#belongs_to_user' do
    context 'given an user_id' do
      it 'returns all keyword search entries of the user' do
        user = Fabricate(:user)
        keyword = Fabricate(:parsed_keyword, user: user) { keyword_search_entries(count: 0) }

        search_entry_a = Fabricate(:keyword_search_entry, keyword_id: keyword.id)
        search_entry_b = Fabricate(:keyword_search_entry, keyword_id: keyword.id)

        result = described_class.belongs_to_user(user.id)

        expect(result).to(contain_exactly(search_entry_a, search_entry_b))
      end
    end
  end
end
