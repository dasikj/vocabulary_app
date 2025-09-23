class UserSignupSeeder
  require "securerandom"
  require "yaml"
  MAX_PER_KIND = 45

  def self.run(user)
    vocab_yaml = Rails.root.join("db/demo_vocabularies.yml")
    sent_yaml  = Rails.root.join("db/demo_sentences.yml")
    import_vocabularies!(user, vocab_yaml) if File.exist?(vocab_yaml)
    import_sentences!(user,  sent_yaml)    if File.exist?(sent_yaml)
  end

  class << self
    private

    def random_hex_color
      format("#%06x", SecureRandom.random_number(0x1000000))
    end

    def attach_unique!(collection, record)
      collection << record unless collection.exists?(id: record.id)
    end

    def import_vocabularies!(user, path)
      data = YAML.load_file(path)
      Array(data["vocabularies"]).first(MAX_PER_KIND).each do |h|
        vocab = user.vocabularies.find_or_create_by!(
          word:    h.fetch("word"),
          reading: h["reading"]
        ) do |v|
          v.meaning        = h["meaning"]
          v.part_of_speech = h["part_of_speech"] # enumなら文字列→整数へ自動変換
          v.example        = h["example"]
        end

        Array(h["vocabulary_tags"]).each do |tag_name|
          tag = user.vocabulary_tags.find_or_initialize_by(name: tag_name)
          tag.color = random_hex_color if tag.respond_to?(:color) && tag.color.blank?
          tag.save!
          attach_unique!(vocab.vocabulary_tags, tag)
        end
      end
    end

    def import_sentences!(user, path)
      data = YAML.load_file(path)
      Array(data["sentences"]).first(MAX_PER_KIND).each do |h|
        sentence = user.sentences.find_or_create_by!(
          body: h.fetch("body")
        ) do |s|
          s.sentence_category = h["sentence_category"] # enumなら文字列→整数へ自動変換
        end

        Array(h["sentence_tags"]).each do |tag_name|
          tag = user.sentence_tags.find_or_initialize_by(name: tag_name)
          tag.color = random_hex_color if tag.respond_to?(:color) && tag.color.blank?
          tag.save!
          attach_unique!(sentence.sentence_tags, tag)
        end
      end
    end
  end
end