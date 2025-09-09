class Sentence < ApplicationRecord
  belongs_to :user
  has_many :sentence_taggings, dependent: :destroy
  has_many :sentence_tags, through: :sentence_taggings
  
  enum sentence_category: {
    metaphor: 0,        # 比喩
    appearance: 1,      # 人物・容姿
    description: 2,     # 情景
    psychology: 3,      # 心理
    conversation: 4,    # 会話
    expression: 5,      # 表現
    logic: 6,           # 論理
    gag: 7,             #ギャグ
    other: 8,           #その他
  }

  validates :body, presence: true, length: { maximum: 400 }, uniqueness: true
  validates :sentence_category, presence: true

  def self.ransackable_associations(_ = nil)
    %w[sentence_taggings sentence_tags user]
  end

  def self.ransackable_attributes(_ = nil)
    %w[body sentence_category created_at updated_at]
  end
end
