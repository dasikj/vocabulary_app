class Vocabulary < ApplicationRecord
  enum part_of_speech: { noun: 0, verb: 1, adjective: 2, adverb: 3, idiom: 4, phrase: 5, other: 6 }

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

