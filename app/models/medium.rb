class Medium < ApplicationRecord
  belongs_to :studio
  has_many :libraries
  has_many :reviews
  has_many :users, through: :libraries
  has_many :media_actors
  has_many :media_directors
  has_many :media_moods
  has_many :media_categories
  has_many :actors, through: :media_actors
  has_many :directors, through: :media_directors
  has_many :moods, through: :media_moods
  has_many :categories, through: :media_categories
  validates :title, presence: true
  validates :synopsys, presence: true
  validates :duration, presence: true
  validates :press_rating, presence: true
  validates :audience_rating, presence: true

  include PgSearch
  pg_search_scope :search_in_all,
    against: [:title, :synopsys, :duration, :year, :country],
    associated_against: {
      categories: [:name],
      moods: [:name],
      directors: [:first_name, :last_name],
      actors: [:first_name, :last_name],
      studio: [:name]
    },
    using: {
      tsearch: { prefix: true } # <-- now `superman batm` will return something!
    }
end
