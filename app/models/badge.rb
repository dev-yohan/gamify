class Badge
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :name, type: String
  slug :name

  field :image, type: String
  mount_uploader :image, ImageUploader

end
