class VocabularyTag < ApplicationRecord
  belongs_to :user
  has_many :vocabulary_taggings, dependent: :destroy
  has_many :vocabularies, through: :vocabulary_taggings

  validates :name, presence: true, uniqueness: { scope: :user_id }
end
