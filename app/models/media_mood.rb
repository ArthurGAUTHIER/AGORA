class MediaMood < ApplicationRecord
  belongs_to :medium
  belongs_to :mood
end
