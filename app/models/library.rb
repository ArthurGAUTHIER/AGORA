class Library < ApplicationRecord
  belongs_to :User
  belongs_to :Medium
  validates :seen, default: false
end
