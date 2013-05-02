class User
  include Mongoid::Document
  include Mongoid::Timestamps

  API_KEY = ENV['TWITTER_API_KEY']
  API_SECRET = ENV['TWITTER_API_SECRET']

  has_many :beacons

  # omniauth fields
  # should move to separate account object
  field :provider, type: String
  field :uid, type: String
  field :name, type: String
  field :token, type: String
  field :secret, type: String

  field :api_token, type: String
  field :expires, type: DateTime
  field :handle, type: String
  field :email, type: String

  validates_uniqueness_of :handle
  validates_uniqueness_of :api_token

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

      user.api_token = user.id
      user.expires = DateTime.now
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

  def self.with_access_token(token)
    puts 'hi'
    puts token
    user = User.where(api_token: token, expires: {"$gt" => DateTime.now}).first
  end

  def as_json(options={})
    {
      id: id,
      updated_at: updated_at.to_i,
      name: name,
      handle: handle
    }
  end

  def authentication_json
    {
      id: id,
      updated_at: updated_at.to_i,
      name: name,
      handle: handle,
      access_token: api_token
    }
  end

  def reset_api_token
    self.api_token = SecureRandom.urlsafe_base64
    self.expires = DateTime.now + 7.days
    save
  end

  def extend_api_token
    self.expires = DateTime.now + 3.days
  end

  def invalidate_token
    update_attribute :expires, DateTime.now
  end
end

