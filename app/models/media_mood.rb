class MediaMood < ApplicationRecord
  belongs_to :Medium
  belongs_to :Mood
end
