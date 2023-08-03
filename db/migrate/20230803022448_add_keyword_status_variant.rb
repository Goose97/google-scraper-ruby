class AddKeywordStatusVariant < ActiveRecord::Migration[7.0]
  def change
    execute <<-SQL
      ALTER TYPE keyword_status ADD VALUE 'pending';
    SQL

    change_column_default :keywords, :status, 'pending'
  end
end
