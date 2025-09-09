class CreateSentences < ActiveRecord::Migration[7.2]
  def change
    create_table :sentences do |t|
      t.text :body
      t.references :user, null: false, foreign_key: true
      t.integer :sentence_category, null: false

      t.timestamps
    end
    add_index :sentences, [ :user_id, :body ], unique: true
  end
end
