class Event
  include Mongoid::Document
  field :name, type: String
  field :value, type: Integer
  field :count, type: Integer
  field :activity_id, type: Integer

  belongs_to :badge, :class_name => "Badge"
end
