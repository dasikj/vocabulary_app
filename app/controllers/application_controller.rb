class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  include Sorcery::Controller
  before_action :require_login

  private
  # Sorcery: 未ログイン時の処理
  def not_authenticated
    redirect_to new_session_path, alert: t("flash.sessions.not_authenticated")
  end
  # ログイン済みならトップページへリダイレクト
  def redirect_if_logged_in
    if logged_in?
      redirect_to top_path, notice: t("flash.sessions.already_logged_in")
    end
  end
end
