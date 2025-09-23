# db/seeds.rb
require "yaml"

# ===== 共通ユーティリティ =====
def attach_unique!(collection, record)
  # collection は has_many :through の関連（例: vocab.vocabulary_tags）
  collection << record unless collection.exists?(id: record.id)
end

def import_vocabularies!(user, yaml_path)
  data = YAML.load_file(yaml_path)
  (data["vocabularies"] || []).each do |h|
    vocab = user.vocabularies.find_or_create_by!(word: h.fetch("word")) do |v|
      v.reading        = h["reading"]
      v.meaning        = h["meaning"]
      v.part_of_speech = h["part_of_speech"]
      v.example        = h["example"]
    end

    Array(h["vocabulary_tags"]).each do |tag_name|
      tag = user.vocabulary_tags.find_or_create_by!(name: tag_name)
      attach_unique!(vocab.vocabulary_tags, tag)
    end
  end
end

def import_sentences!(user, yaml_path)
  data = YAML.load_file(yaml_path)
  (data["sentences"] || []).each do |h|
    sentence = user.sentences.find_or_create_by!(body: h.fetch("body")) do |s|

      s.sentence_category = h["sentence_category"]
    end

    Array(h["sentence_tags"]).each do |tag_name|
      tag = user.sentence_tags.find_or_create_by!(name: tag_name)
      attach_unique!(sentence.sentence_tags, tag)
    end
  end
end

# ===== 2ユーザー作成（同じデータを投入）=====
user1 = User.find_or_create_by!(email: "reviewer1@example.com") do |u|
  u.password = "password"
  u.password_confirmation = "password"
end

user2 = User.find_or_create_by!(email: "reviewer2@example.com") do |u|
  u.password = "password"
  u.password_confirmation = "password"
end

vocab_yaml = Rails.root.join("db/demo_vocabularies.yml")
sent_yaml  = Rails.root.join("db/demo_sentences.yml")

[user1, user2].each do |user|
  import_vocabularies!(user, vocab_yaml)
  import_sentences!(user,  sent_yaml)
end

puts "Seed completed for: #{[user1.email, user2.email].join(', ')}"
