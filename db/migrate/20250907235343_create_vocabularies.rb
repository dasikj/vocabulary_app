class CreateVocabularies < ActiveRecord::Migration[7.2]
  def change
    create_table :vocabularies do |t|
      t.string :word
      t.string :reading
      t.text :meaning
      t.text :example
      t.integer :part_of_speech

      t.timestamps
    end
    add_index :vocabularies, :word, unique: true
  end
end
