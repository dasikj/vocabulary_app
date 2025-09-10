class VocabularyTag < ApplicationRecord
  belongs_to :user
  has_many :vocabulary_taggings, dependent: :destroy
  has_many :vocabularies, through: :vocabulary_taggings

  validates :name, presence: true, 
            length: { maximum: 32},
            uniqueness: { scope: :user_id } # 同一ユーザー内で一意
  validates :color,
            presence: true,
            format: { with: /\A#(?:[0-9a-fA-F]{3}|[0-9a-fA-F]{6})\z/,
                      message: :invalid_color_format } 
  
  
  def self.ransackable_attributes(_ = nil)
    %w[id name user_id created_at updated_at]
  end

  def self.ransackable_associations(_ = nil)
    %w[vocabulary_taggings vocabularies user]
  end
end
