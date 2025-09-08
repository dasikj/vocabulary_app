class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  include Sorcery::Controller

  private
  # ログインを要求するメソッド / ログインしていなければログイン画面へリダイレクト
  def not_authenticated
    redirect_to session_path, alert: t("flash.sessions.require_login")
  end
  # ログイン済みならトップページへリダイレクト
  def redirect_if_logged_in
    if logged_in?
      redirect_to top_path, notice: t("flash.sessions.already_logged_in")
    end
  end
end
