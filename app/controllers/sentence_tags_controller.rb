class SentenceTagsController < ApplicationController

  def index
    @sentence_tags = current_user.sentence_tags.order(:name)
  end

  def new
    @sentence_tag = current_user.sentence_tags.new
  end

  def create
    @sentence_tag = current_user.sentence_tags.new(sentence_tag_params)
    if @sentence_tag.save
      redirect_to sentence_tags_path, notice: "タグを作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    tag = current_user.sentence_tags.find(params[:id])
    if tag.update(sentence_tag_params)
      redirect_to sentence_tags_path, notice: "更新しました"
    else
      redirect_to sentence_tags_path, alert: "更新に失敗しました"
    end
  end

  def destroy
    tag = current_user.sentence_tags.find(params[:id])
    tag.destroy
    redirect_to sentence_tags_path, notice: "削除しました"
  end

  private
  def sentence_tag_params
    params.require(:sentence_tag).permit(:name)
  end
end
