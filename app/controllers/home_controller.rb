class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    # 検索フォーム（TOPのトグル検索用）
    @q_sentence = current_user.sentences.ransack(params[:q_sentence])
    @q_vocab    = current_user.vocabularies.ransack(params[:q_vocab])

    # ===== カレンダー（月別ヒートマップ） =====
    month_param = params[:month].presence
    begin
      base_month = month_param ? Time.zone.parse("#{month_param}-01") : Time.zone.today.beginning_of_month
    rescue
      base_month = Time.zone.today.beginning_of_month
    end

    @month_date = base_month.beginning_of_month
    @start_date = @month_date
    @end_date   = @month_date.end_of_month

    # 6週分のグリッドに収める
    @grid_start = @start_date.beginning_of_week(:sunday)
    @grid_end   = @end_date.end_of_week(:sunday)

    # 遡れる最小月：ユーザー作成月（保険で today フォールバック）
    min_source = current_user&.created_at || Time.zone.today
    @min_month = min_source.beginning_of_month
    @max_month = Time.zone.today.beginning_of_month

    @prev_month = @month_date - 1.month
    @next_month = @month_date + 1.month
    @can_prev   = @prev_month >= @min_month
    @can_next   = @next_month <= @max_month

    # 日別集計
    vocab_counts = current_user.vocabularies.where(created_at: @start_date..@end_date)
                                            .group("DATE(created_at)").count
    sentence_counts = current_user.sentences.where(created_at: @start_date..@end_date)
                                            .group("DATE(created_at)").count

    @day_stats = {}
    (@start_date..@end_date).each do |d|
      v = vocab_counts[d] || 0
      s = sentence_counts[d] || 0
      @day_stats[d] = { vocab: v, sentence: s, total: v + s }
    end
  end
end