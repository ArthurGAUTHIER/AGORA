class Library < ApplicationRecord
  belongs_to :user
  belongs_to :medium
  validates :seen, default: false
end
