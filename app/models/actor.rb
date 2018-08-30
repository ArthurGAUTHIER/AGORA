class Actor < ApplicationRecord
  validates :first_name, presence: true, uniqueness: { scope: :last_name }
  validates :last_name, presence: true
  has_many :media_actors
  has_many :media, through: :media_actors

  def full_name
    first_name << ' ' << last_name
  end
end
