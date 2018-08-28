class Mood < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :media_moods
  has_many :media, trough: :media_moods
end
