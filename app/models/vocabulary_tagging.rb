class VocabularyTagging < ApplicationRecord
  belongs_to :vocabulary_tag
  belongs_to :vocabulary
  validates :vocabulary_tag_id, uniqueness: { scope: :vocabulary_id }
end
