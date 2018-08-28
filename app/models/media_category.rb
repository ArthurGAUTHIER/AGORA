class MediaCategory < ApplicationRecord
  belongs_to :Medium
  belongs_to :Category
end
