module Autocomplete
  class SentencesController < BaseController
    def index
      return render json: [] if term.blank?
      rel = current_user.sentences.where("body ILIKE ?", "%#{term}%").order(:id)
      render_suggestions(rel) { |s| { id: s.id, label: s.body.truncate(40) } }
    end
  end
end
