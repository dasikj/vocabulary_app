class SentenceTagging < ApplicationRecord
  belongs_to :sentence
  belongs_to :sentence_tag

  validates :sentence_id, uniqueness: { scope: :sentence_tag_id } # 重複付与防止
end
