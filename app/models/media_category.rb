class MediaCategory < ApplicationRecord
  belongs_to :medium
  belongs_to :category
end
