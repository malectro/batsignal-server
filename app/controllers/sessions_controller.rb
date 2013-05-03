class SessionsController < ApplicationController
  API_KEY = ENV['TWITTER_API_KEY']
  API_SECRET = ENV['TWITTER_API_SECRET']

  skip_before_filter :require_session

  def create
    auth = request.env["omniauth.auth"]
    auth["provider"] = 'twitter' if auth["provider"] == 'twitter_reverse'
    user = User.where(provider: auth["provider"], uid: auth["uid"]).first || User.create_with_omniauth(auth)
    session[:user_id] = user.id
    respond_to do |format|
      format.html { redirect_to root_url, flash[:notice] => "Signed in!" }
      format.json do
        user.reset_api_token
        render json: user.authentication_json
      end
    end
  end

  def destroy
    session[:user_id] = nil
    current_user.invalidate_token
    respond_to do |format|
      format.json { render json: current_user }
      format.html { redirect_to root_url, flash[:notice] => "Signed out!" }
    end
  end

  def current
    render json: current_user
  end

  def twitter_reverse_auth_token
    consumer = OAuth::Consumer.new(API_KEY, API_SECRET, {
      site: "http://api.twitter.com",
      scheme: "header",
      http_method: :post,
      request_token_path: "/oauth/request_token",
      access_token_path: "/oauth/access_token",
      authorize_path: "/oauth/authorize"
    })

    reverse_auth_token = ""
    request_token = consumer.get_request_token({}, {"x_auth_mode" => "reverse_auth"}) do |token|
      reverse_auth_token = token
      {}
    end

    render json: {sig: reverse_auth_token}
  end

  def twitter_reverse_auth_2

  end
end

