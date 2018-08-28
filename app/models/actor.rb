class Actor < ApplicationRecord
  validates :last_name, presence: true, uniqueness: true
  validates :first_name, presence: true
  has_many :media_actors
end
