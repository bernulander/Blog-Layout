class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def authenticate_user!
    redirect_to new_session_path, alert: 'Please sign in' unless user_signed_in?
  end

  def user_signed_in?
    session[:user_id].present?
  end

  helper_method :user_signed_in?

  def current_user
    User.find session[:user_id] if user_signed_in?
  end
  # make this method accessible in any view file
  helper_method :current_user
end
