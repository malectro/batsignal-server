class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user

  before_filter :require_session

protected

  def require_session
    if !current_user
      render json: {error: :session_expired}, status: :forbidden
    end
  end

private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end

