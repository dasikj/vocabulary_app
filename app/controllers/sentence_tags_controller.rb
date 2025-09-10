class SentenceTagsController < ApplicationController

  def index
    @sentence_tags = current_user.sentence_tags
                                 .order(created_at: :desc)
                                 .page(params[:page]) 
                                 .per(20) 
  end

  def new
    @sentence_tag = current_user.sentence_tags.new
  end

  def create
    @sentence_tag = current_user.sentence_tags.new(sentence_tag_params)
    if @sentence_tag.save
      redirect_to sentence_tags_path, notice: t("flash.sentence_tags.create.success")
    else
      flash.now[:alert] = t("flash.sentence_tags.create.failure")
      render :new, status: :unprocessable_entity
    end
  end

  def update
    tag = current_user.sentence_tags.find(params[:id])
    if tag.update(sentence_tag_params)
      redirect_to sentence_tags_path, notice: t("flash.sentence_tags.update.success")
    else
      redirect_to sentence_tags_path, alert: t("flash.sentence_tags.update.failure")
    end
  end

  def destroy
    tag = current_user.sentence_tags.find(params[:id])
    tag.destroy
    redirect_to sentence_tags_path, notice: t("flash.sentence_tags.destroy.success")
  end

  private
  def sentence_tag_params
    params.require(:sentence_tag).permit(:name, :color)
  end
end
