class CreateVocabularyTaggings < ActiveRecord::Migration[7.2]
  def change
    create_table :vocabulary_taggings do |t|
      t.references :vocabulary_tag, null: false, foreign_key: true
      t.references :vocabulary, null: false, foreign_key: true

      t.timestamps
    end
    add_index :vocabulary_taggings, [ :vocabulary_tag_id, :vocabulary_id ], unique: true
  end
end
