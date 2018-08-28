class Library < ApplicationRecord
  belongs_to :User
  belongs_to :Medium
  validates :seen, presence: true
end
