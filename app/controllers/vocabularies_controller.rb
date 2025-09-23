class VocabulariesController < ApplicationController
  before_action :set_vocabulary, only: [ :show, :update, :destroy ]
  before_action :normalize_vocabulary_search!, only: :index
  def new
    @vocabulary = Vocabulary.new
  end

  def create
    @vocabulary = current_user.vocabularies.build(vocabulary_params)
    if @vocabulary.save
      redirect_to vocabularies_path, notice: t("flash.vocabularies.create.success")
    else
      flash.now[:alert] = t("flash.vocabularies.create.failure")
      render :new, status: :unprocessable_entity
    end
  end

def index
  @q = current_user.vocabularies.ransack(params[:q])
  @vocabularies = search_scope.order(ordering_params).includes(:vocabulary_tags).page(params[:page]).per(10)
  @vocabulary_tags = VocabularyTag.where(user: current_user).order(:name)
end

  def show; end

  def update
    if @vocabulary.update(vocabulary_params)
      redirect_to vocabularies_path(sort: params[:sort].presence || "updated_desc", anchor: "v#{@vocabulary.id}"), notice: t("vocabularies.update.success")
    else
      @vocabulary.restore_attributes
      flash.now[:alert] = t("vocabularies.update.failure")
      render :show, status: :unprocessable_entity
    end
  end

def destroy
  @vocabulary.destroy
  redirect_to vocabularies_path, notice: t("vocabularies.destroy.success")
end

  private

  def vocabulary_params
    p = params.require(:vocabulary).permit(:word, :reading, :meaning, :example, :part_of_speech, vocabulary_tag_ids: [])
    p[:vocabulary_tag_ids] ||= []
    p
  end

  def set_vocabulary
    @vocabulary = current_user.vocabularies.find(params[:id])
  end

  def normalize_vocabulary_search!
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
    base = @q.result.includes(:vocabulary_tags)
    ids = selected_tag_ids
    return base if ids.empty?

    base.joins(:vocabulary_taggings)
        .where(vocabulary_taggings: { vocabulary_tag_id: ids })
        .group("vocabularies.id")
        .having("COUNT(DISTINCT vocabulary_taggings.vocabulary_tag_id) = ?", ids.size)
  end

  def selected_tag_ids
    ids_from_q = Array(params.dig(:q, :vocabulary_tags_id_in))
    ids_from_plain = Array(params[:tag_ids])
    (ids_from_q + ids_from_plain).compact.reject(&:blank?).map(&:to_i).uniq
  end

  def normalize_tag_filters_to_and!
    return unless params[:q].is_a?(ActionController::Parameters) || params[:q].is_a?(Hash)

    ids = Array(params[:q].delete(:vocabulary_tags_id_in)).reject(&:blank?)
    return if ids.blank?

    # Ransack の groupings + m='and' 形式に変換
    params[:q][:m] = "and"
    params[:q][:groupings] = ids.map { |id| { vocabulary_tags_id_eq: id } }
  end

  def ordering_params
    case params[:sort]
    when "updated_asc" then { updated_at: :asc }
    when "created_desc" then { created_at: :desc }
    when "created_asc" then { created_at: :asc }
    else { updated_at: :desc }
    end
  end
end
