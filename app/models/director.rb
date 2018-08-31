class Director < ApplicationRecord
  validates :first_name, presence: true, uniqueness: { scope: :last_name }
  validates :last_name, presence: true
  has_many :media_directors
  has_many :media, through: :media_directors

  def full_name
    first_name << ' ' << last_name
  end
end
