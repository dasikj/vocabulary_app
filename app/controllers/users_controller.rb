class UsersController < ApplicationController
  # ログイン済みならトップページへリダイレクト（new, createアクションのみ）
  before_action :redirect_if_logged_in, only: %i[new create]
  skip_before_action :require_login, only: %i[new create]
  # GET /users/new
  def new
    @user = User.new
  end
  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to new_session_path, notice: t("flash.users.create.success")
    else
      flash.now[:alert] = t("flash.users.create.failure")
      render :new, status: :unprocessable_entity
    end
  end

  private
  # Strong Parametersで許可するパラメータを指定
  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation)
  end
end
