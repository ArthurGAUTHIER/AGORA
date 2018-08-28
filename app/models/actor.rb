class Actor < ApplicationRecord
  validates :last_name, presence: true
  validates :first_name, presence: true
  has_many :media_actor

end
