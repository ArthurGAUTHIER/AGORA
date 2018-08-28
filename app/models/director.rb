class Director < ApplicationRecord
  validates :last_name, presence: true, uniqueness: { scope: :first_name }
  has_many :media_directors
  has_many :media, through: :media_directors
end
