class AddColorToSentenceTags < ActiveRecord::Migration[7.2]
  def change
    add_column :sentence_tags, :color, :string
  end
end
