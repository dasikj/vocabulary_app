class VocabularyTagsController < ApplicationController

  def index
    @vocabulary_tags = current_user.vocabulary_tags
                                 .order(created_at: :desc)
                                 .page(params[:page]) 
                                 .per(20) 
  end

  def new
    @vocabulary_tag = current_user.vocabulary_tags.new
  end

  def create
    @vocabulary_tag = current_user.vocabulary_tags.new(vocabulary_tag_params)
    if @vocabulary_tag.save
      redirect_to vocabulary_tags_path, notice: t("flash.vocabulary_tags.create.success")
    else
      flash.now[:alert] = t("flash.vocabulary_tags.create.failure")
      render :new, status: :unprocessable_entity
    end
  end

  def update
    tag = current_user.vocabulary_tags.find(params[:id])
    if tag.update(vocabulary_tag_params)
      redirect_to vocabulary_tags_path, notice: t("flash.vocabulary_tags.update.success")
    else
      redirect_to vocabulary_tags_path, alert: t("flash.vocabulary_tags.update.failure")
    end
  end

  def destroy
    tag = current_user.vocabulary_tags.find(params[:id])
    tag.destroy
    redirect_to vocabulary_tags_path, notice: t("flash.vocabulary_tags.destroy.success")
  end

  private
  def vocabulary_tag_params
    params.require(:vocabulary_tag).permit(:name, :color)
  end
end