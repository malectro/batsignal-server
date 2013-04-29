class Beacon
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Spacial::Document

  belongs_to :user

  field :geo, type: Array, spacial: true
  field :text, type: String

  def as_json
    {
      id: id,
      updated_at: updated_at.to_i,
      geo: geo,
      text: text
    }
  end

end

