module Autocomplete
  class VocabularyTagsController < BaseController
    def index
      return render json: [] if term.blank?
      rel = current_user.vocabulary_tags.where("name ILIKE ?", "%#{term}%").order(:name)
      render_suggestions(rel) { |t| { id: t.id, label: t.name } }
    end
  end
end
