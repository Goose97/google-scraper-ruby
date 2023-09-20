class AddUserIdToKeywords < ActiveRecord::Migration[7.0]
  def change
    add_reference :keywords, :user, index: true, foreign_key: true, null: false
  end
end
