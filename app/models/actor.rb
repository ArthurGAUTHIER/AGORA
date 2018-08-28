class Actor < ApplicationRecord
  validates :last_name, presence: true, uniqueness: { scope: :first_name }
  has_many :media_actors
  has_many :media, through: :media_actors 
end
