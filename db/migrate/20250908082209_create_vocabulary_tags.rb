class CreateVocabularyTags < ActiveRecord::Migration[7.2]
  def change
    create_table :vocabulary_tags do |t|
      t.string :name
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :vocabulary_tags, [ :user_id, :name ], unique: true
  end
end
