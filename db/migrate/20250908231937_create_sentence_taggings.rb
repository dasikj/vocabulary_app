class CreateSentenceTaggings < ActiveRecord::Migration[7.2]
  def change
    create_table :sentence_taggings do |t|
      t.references :sentence, null: false, foreign_key: true
      t.references :sentence_tag, null: false, foreign_key: true

      t.timestamps
    end
    add_index :sentences_taggings, [ :sentence_id, :sentence_tag_id ], unique: true
  end
end
