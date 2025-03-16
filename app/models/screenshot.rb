class Screenshot < ApplicationRecord
  belongs_to :video
  has_one_attached :file do |attachable|
    attachable.variant :webp, format: :webp
    attachable.variant :thumb, resize_to_limit: [ 320, 320 ], format: :webp
  end

  validates :main, uniqueness: { scope: :video_id }, if: -> { main? }
end
