class ChangeVocabulariesUniqueIndex < ActiveRecord::Migration[7.2]
  def change
    # 既存の word 単独のユニーク制約を削除
    remove_index :vocabularies, :word if index_exists?(:vocabularies, :word)

    # user_id + word の複合ユニーク制約を追加
    add_index :vocabularies, [:user_id, :word], unique: true
  end
end
