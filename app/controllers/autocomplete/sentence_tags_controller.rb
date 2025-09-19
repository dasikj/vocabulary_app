module Autocomplete
  class SentenceTagsController < BaseController
    def index
      return render json: [] if term.blank?
      rel = current_user.sentence_tags.where("name ILIKE ?", "%#{term}%").order(:name)
      render_suggestions(rel) { |t| { id: t.id, label: t.name } }
    end
  end
end
