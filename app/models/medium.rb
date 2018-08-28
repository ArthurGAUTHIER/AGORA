class Medium < ApplicationRecord
  belongs_to :studio
  has_many :media_actor
  has_many :media_director
  has_many :media_mood
  has_many :media_category
  has_many :actors, through: :media_actor
  has_many :directors, through: :media_director
  has_many :moods, through: :media_mood
  has_many :categories, through: :media_category
  validates :title, presence: true
  validates :synopsys, presence: true
  validates :duration, presence: true
  validates :press_rating, presence: true
  validates :audience_rating, presence: true
end
