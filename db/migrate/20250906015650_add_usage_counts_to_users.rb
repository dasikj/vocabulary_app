class AddUsageCountsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :quiz_uses_count, :integer, null: false, default: 0
    add_column :users, :review_uses_count, :integer, null: false, default: 0
  end
end
