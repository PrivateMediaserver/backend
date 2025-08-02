class VideoFragment < ApplicationRecord
  has_one_attached :file
  belongs_to :video
end
