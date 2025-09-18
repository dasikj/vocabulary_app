class CreateAddIndexesToBookmarks < ActiveRecord::Migration[7.2]
  def change
    add_index :bookmarks, [:user_id, :bookmarkable_type, :bookmarkable_id],
              unique: true, name: "index_bookmarks_uniqueness"
    add_index :bookmarks, [:bookmarkable_type, :bookmarkable_id],
              name: "index_bookmarks_on_target"
  end
end
