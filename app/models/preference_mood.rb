class PreferenceMood < ApplicationRecord
  belongs_to :user
  belongs_to :mood
end
