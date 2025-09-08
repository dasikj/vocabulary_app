class VocabulariesController < ApplicationController
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

  private

  def vocabulary_params
    params.require(:vocabulary).permit(:word, :reading, :meaning, :example, :part_of_speech)
  end
end
