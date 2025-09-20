module BookmarksHelper
  def bookmarked?(record)
    return false unless current_user
    current_user.bookmarks.exists?(bookmarkable: record)
  end

  def bookmark_for(record)
    current_user&.bookmarks&.find_by(bookmarkable: record)
  end

  # タグ名の配列化（モデル差異を吸収）
  def tags_for(record)
    if record.respond_to?(:tags)
      Array(record.tags).map { |t| t.respond_to?(:name) ? t.name : t.to_s }
    elsif record.respond_to?(:vocabulary_tags)
      Array(record.vocabulary_tags).map { |t| t.respond_to?(:name) ? t.name : t.to_s }
    elsif record.respond_to?(:sentence_tags)
      Array(record.sentence_tags).map { |t| t.respond_to?(:name) ? t.name : t.to_s }
    else
      []
    end
  end

  # 品詞 enum を翻訳
  def translate_part_of_speech(pos_value)
    return if pos_value.blank?
    I18n.t("enums.vocabulary.part_of_speech.#{pos_value}", default: pos_value)
  end

  # 文章種類 enum を翻訳
  def translate_sentence_category(cat_value)
    return if cat_value.blank?
    I18n.t("enums.sentence.sentence_category.#{cat_value}", default: cat_value)
  end
end
