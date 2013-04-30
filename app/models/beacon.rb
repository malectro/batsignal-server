class Beacon
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Spacial::Document
  include Mongoid::Realization

  belongs_to :user

  field :geo, type: Array, spacial: true
  field :text, type: String

  def as_json(options={})
    {
      id: id,
      updated_at: updated_at.to_i,
      geo: geo,
      text: text,
      user: user.as_json
    }
  end

end

