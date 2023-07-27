class CreateKeywords < ActiveRecord::Migration[7.0]
  def change
    create_enum  :keyword_status, %w[processing succeeded failed]

    create_table :keywords, id: :serial do |t|
      t.string :content, limit: 255, null: false
      t.enum :status, enum_type: 'keyword_status', default: 'processing', null: false
      t.text :result_page_html
      t.integer :links_count
      t.timestamps
    end

    create_enum  :search_entry_kind, %w[ads non_ads]

    create_enum  :search_entry_position, %w[top bottom]

    create_table :keyword_search_entries, id: :serial do |t|
      t.enum :kind, enum_type: 'search_entry_kind', null: false
      t.string :urls, array: true, default: []
      t.enum :position, enum_type: 'search_entry_position'
      t.timestamps

      t.references :keyword, foreign_key: { on_delete: :cascade }, null: false
    end
  end
end
