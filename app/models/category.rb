class Category < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :media_categories
  has_many :media, through: :media_categories
end
