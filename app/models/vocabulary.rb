class Vocabulary < ApplicationRecord
  enum part_of_speech: {
    noun: 0,        # 名詞
    verb: 1,        # 動詞
    adjective: 2,   # 形容詞（形容動詞も含む）
    adverb: 3,      # 副詞
    idiom: 4,       # 四字熟語
    phrase: 5,      # 慣用句
    other: 6        # その他
  }

  validates :word, presence: true, length: { maximum: 100 }
  validates :reading, length: { maximum: 100 }, allow_blank: true
  validates :meaning, presence: true
  validates :example, length: { maximum: 1000 }, allow_blank: true
  validates :part_of_speech, presence: true
end
