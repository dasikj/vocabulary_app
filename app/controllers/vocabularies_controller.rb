class VocabulariesController < ApplicationController
  before_action :set_vocabulary, only: [:edit,:show, :update, :destroy]
  before_action :normalize_vocabulary_search!, only: :index
  def new
    @vocabulary = Vocabulary.new
  end

  def create
    @vocabulary = Vocabulary.new(vocabulary_params)
    if @vocabulary.save
      redirect_to vocabularies_path, notice: t("flash.vocabularies.create.success")
    else
      flash.now[:alert] = t("flash.vocabularies.create.failure")
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @q = Vocabulary.ransack(params[:q])
    @vocabularies = @q.result.order(created_at: :desc).page(params[:page]).per(10)
  end

  #editいらない可能性あり
  def edit; end
  def show; end

  def update
    if @vocabulary.update(vocabulary_params)
      redirect_to vocabularies_path, notice: t("vocabularies.update.success")
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
    params.require(:vocabulary).permit(:word, :reading, :meaning, :example, :part_of_speech)
  end

  def set_vocabulary
    @vocabulary = Vocabulary.find(params[:id])
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
end
