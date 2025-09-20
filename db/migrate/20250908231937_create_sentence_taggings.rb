class CreateSentenceTaggings < ActiveRecord::Migration[7.2]
  def up
    return if table_exists?(:sentence_taggings)

    create_table :sentence_taggings do |t|
      t.references :sentence,      null: false, foreign_key: true
      t.references :sentence_tag,  null: false, foreign_key: true
      t.timestamps
    end
    add_index :sentence_taggings, [ :sentence_id, :sentence_tag_id ], unique: true
  end

  def down
    drop_table :sentence_taggings, if_exists: true
  end
end
