class AddKeywordSearchEntryPositionVariant < ActiveRecord::Migration[7.0]
  def change
    execute <<-SQL
      ALTER TYPE search_entry_position ADD VALUE 'main_search';
    SQL
  end
end
