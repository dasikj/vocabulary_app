class HomeController < ApplicationController
  before_action :require_login

  def index
    # month = (params[:month] || Date.current).to_date
    # @first, @last = month.beginning_of_month, month.end_of_month

    # v = current_user.vocabularies.where(created_at: @first..@last)
    #     .group("DATE(created_at)").count
    # s = current_user.sentences.where(created_at: @first..@last)
    #     .group("DATE(created_at)").count

    # start = @first.beginning_of_week(:monday)
    # finish = @last.end_of_week(:monday)
    # @days = (start..finish).map { |d|
    #  { date: d, vocab: v[d] || 0, sent: s[d] || 0, in_month: d.month == @first.month }
    # }
  end
end
