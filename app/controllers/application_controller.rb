class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :authenticate_user!, unless: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name])
    end

  # Deviseのリダイレクト先を明示（/ へのマッピングエラー回避）
  def after_sign_in_path_for(_resource)
    authenticated_root_path
  end

  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end

  private
  # ログイン済みならトップページへリダイレクト
  def redirect_if_logged_in
    if user_signed_in?
      redirect_to top_path, notice: t("flash.sessions.already_logged_in")
    end
  end
end
