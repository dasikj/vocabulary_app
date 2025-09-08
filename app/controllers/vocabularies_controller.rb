class VocabulariesController < ApplicationController
  before_action :set_vocabulary, only: [:edit,:show, :update, :destroy]
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
    #あとでper10-20あたりに変更する
    @vocabularies = Vocabulary.order(created_at: :desc).page(params[:page]).per(1)
  end

  #editいらない可能性あり
  def edit; end
  def show; end

  def update
    if @vocabulary.update(vocabulary_params)
      redirect_to vocabularies_path, notice: t("vocabularies.update.success")
    else
      flash.now[:alert] = t("vocabularies.update.failure")
      render :edit, status: :unprocessable_entity
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
end
