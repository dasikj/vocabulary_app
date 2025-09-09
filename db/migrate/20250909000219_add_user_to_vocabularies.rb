class AddUserToVocabularies < ActiveRecord::Migration[7.2]
  def change
    add_reference :vocabularies, :user, null: false, foreign_key: true
  end
end
