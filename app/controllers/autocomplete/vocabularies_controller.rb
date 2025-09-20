module Autocomplete
  class VocabulariesController < BaseController
    def index
      return render json: [] if term.blank?

      rel = current_user.vocabularies
        .where("word ILIKE :q OR reading ILIKE :q", q: "%#{term}%")
        .order(:word)

      render_suggestions(rel) do |v|
        {
          id: v.id,
          label: v.word,                # 表示の主テキスト
          reading: v.reading.presence   # 画面でサブ表示に使える（nilなら非表示）
        }
      end
    end
  end
end