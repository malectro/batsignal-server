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

  field :handle, type: String
  field :email, type: String

  validates_uniqueness_of :handle

  attr_accessible :name, :handle, :email

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      user.token = auth["credentials"]["token"]
      user.secret = auth["credentials"]["secret"]

      if user.name
        user.handle = user.name.split(' ')[0] + user.id.to_s
      else
        user.handle = "user#{user.id}"
      end
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

  def as_json(options={})
    {
      id: id,
      updated_at: updated_at.to_i,
      name: name,
      handle: handle
    }
  end
end

