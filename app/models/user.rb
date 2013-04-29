class User
  include Mongoid::Document
  include Mongoid::Timestamps

  API_KEY = ENV['TWITTER_API_KEY']
  API_SECRET = ENV['TWITTER_API_SECRET']

  has_many :beacons

  # omniauth fields
  field :provider, type: String
  field :uid, type: String
  field :name, type: String
  field :token, type: String
  field :secret, type: String

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      user.token = auth["credentials"]["token"]
      user.secret = auth["credentials"]["secret"]
    end
  end

  def self.addurls(urls)
    user.urls = urls
  end

  def self.prepare_access_token(user)
    consumer = OAuth::Consumer.new(API_KEY, API_SECRET, {
      site: "http://www.twitter.com/"
    })

    #token_hash = {:oauth_token => user.token,:oauth_token_secret => user.secret}
    access_token = OAuth::AccessToken.new(consumer, user.token, user.secret)
  end

  def as_json
    {
      id: id,
      name: name,
      updated_at: updated_at.to_i
    }
  end
end

