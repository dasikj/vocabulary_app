class VocabQuizzesController < ApplicationController

  QUIZ_KEY = :vocab_quiz

  def new
    @vocabulary_tags = current_user.vocabulary_tags.order(:name)
    @cond = session[:vocab_quiz_cond] || {}
    params[:only_favorites] = "1" if @cond[:only_favorites] && !params.key?(:only_favorites)
  end

  def create
    pattern = params[:pattern].presence_in(%w[choice input]) || "choice"
    tag_ids = Array(params[:vocabulary_tags_id_in]).map(&:to_i).reject(&:zero?)
    from    = params[:from].presence
    to      = params[:to].presence
    only_favorites = params[:only_favorites].present?

    scope = current_user.vocabularies

    # お気に入りのみ（ユーザーのブックマーク）に絞る（ポリモーフィック Bookmark）
    if only_favorites
      scope = scope.where(
        id: Bookmark.where(user_id: current_user.id, bookmarkable_type: "Vocabulary").select(:bookmarkable_id)
      )
    end

    # 期間フィルタ
    scope = scope.where("vocabularies.created_at >= ?", from.to_date.beginning_of_day) if from
    scope = scope.where("vocabularies.created_at <= ?", to.to_date.end_of_day) if to

    # タグは AND 条件（選択した全タグを持つ語彙）
    if tag_ids.any?
      scope = scope.joins(:vocabulary_taggings)
                   .where(vocabulary_taggings: { vocabulary_tag_id: tag_ids })
                   .group("vocabularies.id")
                   .having("COUNT(DISTINCT vocabulary_taggings.vocabulary_tag_id) = ?", tag_ids.size)
    end

    # 先に候補IDを取り出し、Ruby 側でサンプリングする
    candidate_ids = scope.pluck(:id)  # group済みなので重複しない
    if candidate_ids.size < 10
      redirect_to new_vocab_quiz_path, alert: t("flash.vocab_quiz.too_few_questions", default: "登録語彙が少なすぎます（10個以上必要）") and return
    end
    picked_ids = candidate_ids.sample(10)
    questions = current_user.vocabularies.where(id: picked_ids).to_a

    distractor_pool = current_user.vocabularies.where.not(id: questions.map(&:id)).pluck(:id, :meaning)
    if pattern == "choice" && distractor_pool.size < 3
      redirect_to new_vocab_quiz_path, alert: t("flash.vocab_quiz.too_few_distractors", default: "外れ選択肢を用意できません") and return
    end

    session[QUIZ_KEY] = {
      "pattern" => pattern,
      "q_ids"   => questions.map(&:id),
      "answers" => {},
      "score"   => 0
    }

    session[:vocab_quiz_cond] = {
      pattern: pattern,
      vocabulary_tags_id_in: tag_ids,
      from: from,
      to: to,
      only_favorites: only_favorites
    }

    redirect_to vocab_quiz_path(id: "run", q: 1)
  end

  def show
    data = session[QUIZ_KEY]
    unless data.present?
      redirect_to new_vocab_quiz_path, alert: t("flash.vocab_quiz.no_session", default: "問題が未作成です") and return
    end

    @pattern = data["pattern"]
    @index   = params[:q].to_i.clamp(1, 10)
    @total   = data["q_ids"].size
    @vocab   = current_user.vocabularies.find(data["q_ids"][@index - 1])

    if @pattern == "choice"
      @choices = build_choices_for(@vocab, data["q_ids"])
    end
  end

  def update
    data = session[QUIZ_KEY]
    unless data.present?
      redirect_to new_vocab_quiz_path, alert: t("flash.vocab_quiz.no_session", default: "問題が未作成です") and return
    end

    pattern = data["pattern"]
    index   = params[:q].to_i
    vocab   = current_user.vocabularies.find(data["q_ids"][index - 1])

    correct =
      if pattern == "choice"
        params[:answer].to_s == vocab.meaning.to_s
      else
        normalize(params[:answer]) == normalize(vocab.word)
      end

    data["answers"][index.to_s] = { "user_answer" => params[:answer].to_s, "correct" => correct }
    data["score"] = data["answers"].values.count { |h| h["correct"] }

    session[QUIZ_KEY] = data

    if index >= data["q_ids"].size
      redirect_to result_vocab_quizzes_path
    else
      redirect_to vocab_quiz_path(id: "run", q: index + 1)
    end
  end

  def result
    data = session[QUIZ_KEY]
    unless data.present?
      redirect_to new_vocab_quiz_path, alert: t("flash.vocab_quiz.no_session", default: "問題が未作成です") and return
    end

    # ← ここで完了カウント
    current_user.increment!(:quiz_uses_count)

    @score = data["score"]
    @total = data["q_ids"].size
    @answers = data["answers"]
    ids = data["q_ids"]
    records = current_user.vocabularies.where(id: ids).index_by(&:id)
    @vocabularies = ids.map { |i| records[i] }.compact

    @cond = session[:vocab_quiz_cond] || {}
    session.delete(QUIZ_KEY)
  end

  private

  def build_choices_for(vocab, current_ids)
    correct = vocab.meaning.to_s
    pool = current_user.vocabularies.where.not(id: current_ids)
              .where.not(meaning: [ nil, "", correct ])
              .order("RANDOM()").limit(20).pluck(:meaning).uniq
    extra = current_user.vocabularies.where.not(id: vocab.id)
              .where.not(meaning: [ nil, "", correct ])
              .order("RANDOM()").limit(20).pluck(:meaning).uniq
    pool |= extra

    distractors = pool.reject { |m| m == correct }.first(3)
    if distractors.size < 3
      redirect_to new_vocab_quiz_path, alert: t("flash.vocab_quiz.too_few_distractors", default: "外れ選択肢を用意できません") and return
    end
    (distractors + [ correct ]).shuffle
  end

  def normalize(str)
    s = str.to_s.strip
    s = s.tr("　", " ")
    s.mb_chars.downcase.to_s
  end
end
