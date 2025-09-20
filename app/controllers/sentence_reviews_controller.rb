class SentenceReviewsController < ApplicationController
  before_action :authenticate_user!

  KEY = :sentence_review

  def new
    @sentence_tags = current_user.sentence_tags.order(:name)
  end

  def create
    tag_ids = Array(params[:sentence_tags_id_in]).map(&:to_i).reject(&:zero?)
    from    = params[:from].presence
    to      = params[:to].presence
    only_favorites = params[:only_favorites].present?

    scope = current_user.sentences

    # お気に入りのみ（ユーザーのブックマーク）に絞る（存在する関連に応じて安全に絞り込み）
    if only_favorites
      if current_user.respond_to?(:favorite_sentences)
        # 典型: has_many :favorite_sentences, -> { where(bookmarks...) }
        scope = current_user.favorite_sentences.merge(scope)
      elsif Sentence.reflect_on_association(:sentence_bookmarks)
        # 典型: Sentence has_many :sentence_bookmarks (user_id, sentence_id)
        scope = scope.joins(:sentence_bookmarks).where(sentence_bookmarks: { user_id: current_user.id })
      elsif defined?(SentenceFavorite)
        # 典型: 中間テーブル SentenceFavorite(user_id, sentence_id)
        scope = scope.where(id: SentenceFavorite.where(user_id: current_user.id).select(:sentence_id))
      elsif defined?(Bookmark)
        # 典型: ポリモーフィック Bookmark
        scope = scope.where(id: Bookmark.where(user_id: current_user.id, bookmarkable_type: "Sentence").select(:bookmarkable_id))
      else
        # 何もしない（関連が不明）
      end
    end

    scope = scope.where("sentences.created_at >= ?", from.to_date.beginning_of_day) if from
    scope = scope.where("sentences.created_at <= ?", to.to_date.end_of_day) if to

    # タグは AND 条件（選択した全タグを持つ文章）
    if tag_ids.any?
      scope = scope.joins(:sentence_taggings)
                   .where(sentence_taggings: { sentence_tag_id: tag_ids })
                   .group("sentences.id")
                   .having("COUNT(DISTINCT sentence_taggings.sentence_tag_id) = ?", tag_ids.size)
    end

    candidate_ids = scope.pluck(:id)
    if candidate_ids.size < 10
      redirect_to new_sentence_review_path, alert: t("flash.sentence_reviews.too_few", default: "登録されている文章が少なすぎます（10個以上必要）") and return
    end

    ids = candidate_ids.sample(10)
    session[KEY] = {
      "ids"   => ids,
      "index" => 1,
      "cond"  => { sentence_tags_id_in: tag_ids, from: from, to: to } # 将来の再実行に備えて保持
    }

    redirect_to sentence_review_path(id: "run", q: 1)
  end

  def show
    data = session[KEY]
    unless data.present?
      redirect_to new_sentence_review_path, alert: t("flash.sentence_reviews.no_session", default: "復習が未作成です") and return
    end

    @index    = params[:q].to_i.clamp(1, 10)
    @total    = data["ids"].size
    @sentence = current_user.sentences.find(data["ids"][@index - 1])

    # 最終到達時に終了ボタンでセッションクリア
    @last = (@index >= @total)
  end

  def complete
  data = session[KEY]
    if data.present?
      current_user.increment!(:review_uses_count)
      session.delete(KEY)
      redirect_to new_sentence_review_path, notice: t("flash.sentence_reviews.completed", default: "お疲れさまでした。")
    else
      redirect_to new_sentence_review_path, alert: t("flash.sentence_reviews.no_session", default: "復習が未作成です")
    end
  end

end
