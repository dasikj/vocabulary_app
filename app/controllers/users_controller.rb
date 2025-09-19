class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @vocab_count = @user.vocabularies.count
    @sentence_count = @user.sentences.count
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to user_path, notice: t("flash.users.update.success", default: "ユーザー情報を更新しました")
    else
      flash.now[:alert] = t("flash.users.update.failure", default: "更新に失敗しました")
      render :show, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end
end
