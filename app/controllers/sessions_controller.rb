class SessionsController < ApplicationController
  API_KEY = ENV['TWITTER_API_KEY']
  API_SECRET = ENV['TWITTER_API_SECRET']

  def create
    auth = request.env["omniauth.auth"]
    user = User.where(provider: auth["provider"], uid: auth["uid"]).first || User.create_with_omniauth(auth)
    session[:user_id] = user.id
    redirect_to root_url, flash[:notice] => "Signed in!"
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, flash[:notice] => "Signed out!"
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

