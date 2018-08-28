class Mood < ApplicationRecord
  validates :name, presence: true
  has_many :media_mood
end
