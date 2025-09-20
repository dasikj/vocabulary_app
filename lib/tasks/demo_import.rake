require "yaml"

namespace :demo do
  def random_color
    "#" + "%06x" % (rand * 0xffffff)
  end

  desc "Import demo vocabularies and sentences from YAML"
  task import_yaml: :environment do
    user = User.find_or_create_by!(email: "demo@example.com") do |u|
      u.password = "password"
      u.name = "Demo User"
    end

    vocab_file = Rails.root.join("db/demo_vocabularies.yml")
    sent_file  = Rails.root.join("db/demo_sentences.yml")

    if File.exist?(vocab_file)
      data = YAML.load_file(vocab_file)
      data["vocabularies"].each do |attrs|
        v = user.vocabularies.create!(
          word: attrs["word"],
          reading: attrs["reading"],
          part_of_speech: attrs["part_of_speech"],
          meaning: attrs["meaning"],
          example: attrs["example"]
        )
        if attrs["vocabulary_tags"]
          attrs["vocabulary_tags"].each do |tag_name|
            tag = VocabularyTag.find_or_initialize_by(name: tag_name, user: user)
            tag.color ||= random_color
            tag.save!
            v.vocabulary_tags << tag unless v.vocabulary_tags.include?(tag)
          end
        end
      end
    end

    if File.exist?(sent_file)
      data = YAML.load_file(sent_file)
      data["sentences"].each do |attrs|
        s = user.sentences.create!(
          body: attrs["body"],
          sentence_category: attrs["sentence_category"]
        )
        if attrs["sentence_tags"]
          attrs["sentence_tags"].each do |tag_name|
            tag = SentenceTag.find_or_initialize_by(name: tag_name, user: user)
            tag.color ||= random_color
            tag.save!
            s.sentence_tags << tag unless s.sentence_tags.include?(tag)
          end
        end
      end
    end

    puts "✅ Demo data imported for #{user.email}"
  end

  desc "Clear demo data"
  task clear_yaml: :environment do
    user = User.find_by(email: "demo@example.com")
    if user
      user.vocabularies.destroy_all
      user.sentences.destroy_all
      puts "🗑 Demo data cleared."
    else
      puts "No demo user found."
    end
  end

  desc "Reset demo data"
  task reset_yaml: [ :clear_yaml, :import_yaml ]
end
