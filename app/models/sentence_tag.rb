class SentenceTag < ApplicationRecord
  belongs_to :user
  has_many :sentence_taggings, dependent: :destroy
  has_many :sentences, through: :sentence_taggings

  validates :name, presence: true
  validates :name, uniqueness: { scope: :user_id }   # 同一ユーザー内で一意

  def self.ransackable_attributes(_ = nil)
    %w[id name user_id created_at updated_at]
  end

  def self.ransackable_associations(_ = nil)
    %w[sentence_taggings sentences user]
  end
  
end