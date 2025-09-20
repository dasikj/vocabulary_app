module Autocomplete
  class BaseController < ApplicationController
    private
    def term
      params[:term].to_s.strip
    end
    def render_suggestions(records, &block)
      suggestions = records.limit(10).map { |r| block ? block.call(r) : { id: r.id, label: r.to_s } }
      render json: suggestions
    end
  end
end
