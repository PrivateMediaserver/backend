class Video < ApplicationRecord
  has_one_attached :file
  belongs_to :user
  has_many :video_fragments, dependent: :destroy
  has_many :screenshots, dependent: :destroy
  has_one :preview, -> { where(main: true) }, class_name: "Screenshot"
  has_many :video_people, dependent: :destroy
  has_many :people, through: :video_people
  has_many :video_tags, dependent: :destroy
  has_many :tags, through: :video_tags

  enum :status, unprocessed: 0, processing: 1, processed: 2

  generates_token_for :playlist, expires_in: 1.minute do
    updated_at
  end

  def viewed
    (progress / duration * 100) > 85
  end
end
