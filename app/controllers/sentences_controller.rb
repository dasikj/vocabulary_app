class SentencesController < ApplicationController
  before_action :set_sentence, only: [ :show, :update, :destroy ]
  before_action :normalize_sentence_search!, only: :index
  def new
    @sentence = Sentence.new
  end

  def create
    @sentence = current_user.sentences.build(sentence_params)
    if @sentence.save
      redirect_to sentences_path, notice: t("flash.sentences.create.success")
    else
      flash.now[:alert] = t("flash.sentences.create.failure")
      render :new, status: :unprocessable_entity
    end
  end

def index
  @q = current_user.sentences.ransack(params[:q])
  scope = search_scope
  @sentences = scope.order(ordering_params)
                    .includes(:sentence_tags)
                    .page(params[:page]).per(10)
  @sentence_tags = SentenceTag.where(user: current_user).order(:name)
end

  def show; end

  def update
    if @sentence.update(sentence_params)
      redirect_to sentences_path(sort: params[:sort].presence || 'updated_desc', anchor: "s#{@sentence.id}"), notice: t("sentences.update.success")
    else
      @sentence.restore_attributes
      flash.now[:alert] = t("sentences.update.failure")
      render :show, status: :unprocessable_entity
    end
  end

def destroy
  @sentence.destroy!
  redirect_to sentences_path, notice: t("sentences.destroy.success")
end

  private

  def sentence_params
    p = params.require(:sentence).permit(:body, :sentence_category, sentence_tag_ids: [])
    p[:sentence_tag_ids] ||= []
    p
  end

  def set_sentence
    @sentence = current_user.sentences.find(params[:id])
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
    base = @q.result.includes(:sentence_tags)

    ids = selected_tag_ids
    return base if ids.blank?

    if ids.size == 1
      base.joins(:sentence_taggings).where(sentence_taggings: { sentence_tag_id: ids.first }).distinct
    else
      base.joins(:sentence_taggings)
          .where(sentence_taggings: { sentence_tag_id: ids })
          .group('sentences.id')
          .having('COUNT(DISTINCT sentence_taggings.sentence_tag_id) = ?', ids.size)
    end
  end

  def selected_tag_ids
    ids_from_q     = Array(params.dig(:q, :sentence_tags_id_in))
    ids_from_plain = Array(params[:tag_ids])
    (ids_from_q + ids_from_plain).compact.reject(&:blank?).map(&:to_i).uniq
  end

  def ordering_params
    case params[:sort]
    when 'updated_asc' then { updated_at: :asc }
    when 'created_desc' then { created_at: :desc }
    when 'created_asc' then { created_at: :asc }
    else { updated_at: :desc }
    end
  end

end
