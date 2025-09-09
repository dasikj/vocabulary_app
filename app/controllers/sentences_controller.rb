class SentencesController < ApplicationController
  before_action :set_sentence, only: [ :show, :update, :destroy ]
  before_action :normalize_sentence_search!, only: :index
  def new
    @sentence = Sentence.new
  end

  def create
    @sentence = Sentence.new(sentence_params)
    if @sentence.save
      redirect_to sentences_path, notice: t("flash.sentences.create.success")
    else
      flash.now[:alert] = t("flash.sentences.create.failure")
      render :new, status: :unprocessable_entity
    end
  end

def index
  @q = Sentence.ransack(params[:q])
  @sentences = search_scope.page(params[:page]).per(10)
  @sentence_tags = SentenceTag.where(user: current_user).order(:name)
end

  def show; end

  def update
    if @sentence.update(sentence_params)
      redirect_to sentences_path, notice: t("sentences.update.success")
    else
      @sentence.restore_attributes
      flash.now[:alert] = t("sentences.update.failure")
      render :show, status: :unprocessable_entity
    end
  end

def destroy
  @sentence.destroy
  redirect_to sentences_path, notice: t("sentences.destroy.success")
end

  private

  def sentence_params
    params.require(:sentence).permit(:body, :sentence_category)
  end

  def set_sentence
    @sentence = Sentence.find(params[:id])
  end

  def normalize_sentence_search!
    return unless params[:q].present?
    q = params[:q]

    if q["created_at_gteq"].present?
      q["created_at_gteq"] = Time.zone.parse(q["created_at_gteq"]).beginning_of_day
    end
    if q["created_at_lteq"].present?
      q["created_at_lteq"] = Time.zone.parse(q["created_at_lteq"]).end_of_day
    end
  end
  def search_scope
    base = @q.result.includes(:sentence_tags).order(created_at: :desc)
    ids = selected_tag_ids
    return base if ids.empty?

    base.joins(:sentence_taggings)
        .where(sentence_taggings: { sentence_tag_id: ids })
        .group("sentences.id")
        .having("COUNT(DISTINCT sentence_taggings.sentence_tag_id) = ?", ids.size)
  end

  def selected_tag_ids
    Array(params[:tag_ids]).map(&:to_i).uniq
  end
end
