class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user

  before_filter :require_session

protected

  def require_session
    if !current_user
      # i'd rather use :unauthorized here, but for some reason apple is a dick about it
      render json: {error: :session_expired}, status: :forbidden
    end
  end

private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    @current_user ||= authenticate_with_http_token do |token, options|
      User.with_access_token(token)
    end
  end
end

