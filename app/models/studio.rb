class Studio < ApplicationRecord
  has_many :medium
  validates :name, presence:true
end
