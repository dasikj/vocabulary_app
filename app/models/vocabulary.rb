class Vocabulary < ApplicationRecord
  has_many :vocabulary_taggings, dependent: :destroy
  has_many :vocabulary_tags, through: :vocabulary_taggings
  enum part_of_speech: {
    noun: 0,        # 名詞
    verb: 1,        # 動詞
    adjective: 2,   # 形容詞（形容動詞も含む）
    adverb: 3,      # 副詞
    idiom: 4,       # 四字熟語
    phrase: 5,      # 慣用句
    other: 6        # その他
  }

  validates :word, presence: true, length: { maximum: 100 }, uniqueness: true
  validates :reading, length: { maximum: 100 }, allow_blank: true
  validates :meaning, presence: true
  validates :example, length: { maximum: 1000 }, allow_blank: true
  validates :part_of_speech, presence: true

  def self.ransackable_attributes(_auth = nil)
    %w[word reading meaning example part_of_speech created_at]
  end
  
  def self.ransackable_associations(_auth = nil)
    %w[vocabulary_tags]
  end
end
