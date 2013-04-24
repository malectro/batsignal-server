class Signal
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Spacial::Document

  belongs_to :user

  field :geo, type: Array, spacial: true
  field :text, type: String

end

