class Studio < ApplicationRecord
  has_many :media
  validates :name, presence:true, uniqueness: true
end
