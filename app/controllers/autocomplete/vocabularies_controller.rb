module Autocomplete
  class VocabulariesController < BaseController
    def index
      return render json: [] if term.blank?
      rel = current_user.vocabularies.where("word ILIKE ?", "%#{term}%").order(:word)
      render_suggestions(rel) { |v| { id: v.id, label: v.word } }
    end
  end
end
