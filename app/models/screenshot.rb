class Screenshot < ApplicationRecord
  belongs_to :video
  has_one_attached :file do |attachable|
    attachable.variant :avif, format: :avif
    attachable.variant :thumb, resize_to_limit: [ 480, 480 ], format: :avif
  end

  validates :main, uniqueness: { scope: :video_id }, if: -> { main? }
end
