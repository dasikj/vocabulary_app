class AddColorToVocabularyTags < ActiveRecord::Migration[7.2]
  def change
    add_column :vocabulary_tags, :color, :string
  end
end
