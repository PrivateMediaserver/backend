class Screenshot < ApplicationRecord
  belongs_to :video
  has_one_attached :file do |attachable|
    attachable.variant :webp, format: :webp
    attachable.variant :thumb, resize_to_limit: [ 480, 480 ], format: :webp
  end

  before_validation :unset_other_mains, if: -> { main? && will_save_change_to_main? }

  validates :main, uniqueness: { scope: :video_id }, if: -> { main? }

  private

  def unset_other_mains
    Screenshot.where(video_id: video_id, main: true)
              .where.not(id: id)
              .update_all(main: false)
  end
end
