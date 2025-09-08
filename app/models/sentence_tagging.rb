class SentenceTagging < ApplicationRecord
  belongs_to :sentence
  belongs_to :sentence_tag
end
