class Vocabulary < ApplicationRecord
  belongs_to :user
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

  validates :reading, length: { maximum: 100 }, allow_blank: true
  validates :meaning, presence: true, length: { maximum: 300 }
  validates :example, length: { maximum: 500 }, allow_blank: true
  validates :part_of_speech, presence: true
  validates :word, presence: true, length: { maximum: 100 }, uniqueness: { scope: :user_id }
  validate :limit_vocabulary_tags_count

  def self.ransackable_attributes(_auth = nil)
    %w[word reading meaning example part_of_speech created_at updated_at]
  end

  def self.ransackable_associations(_auth = nil)
    %w[vocabulary_tags vocabulary_taggings user]
  end

  private
  # 紐付けできるタグを制限する
  def limit_vocabulary_tags_count
    max = 10 # 最大10個まで
    if vocabulary_tag_ids.uniq.size > max
    errors.add(:vocabulary_tags, :too_many_tags, count: max)
    end
  end
end
