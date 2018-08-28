class Category < ApplicationRecord
  validates :name, presence: true
  has_many :media_category
end
