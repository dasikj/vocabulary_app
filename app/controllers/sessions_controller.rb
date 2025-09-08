class SessionsController < ApplicationController
  # ログイン済みならトップページへリダイレクト（new, createアクションのみ）
  before_action :redirect_if_logged_in, only: %i[new create]
  def new; end

  def create
    @user = login(params[:email], params[:password])
    if @user
      redirect_to top_path, notice: t("flash.sessions.create.success")
    else
      flash.now[:alert] = t("flash.sessions.create.failure")
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: t("flash.sessions.destroy.success")
  end
end
