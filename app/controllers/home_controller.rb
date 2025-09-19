class HomeController < ApplicationController

  def index
    # TOP 検索用（トグル：文章 / 語彙）
    @q_sentence = current_user.sentences.ransack(params[:q_sentence])
    @q_vocab    = current_user.vocabularies.ransack(params[:q_vocab])

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
