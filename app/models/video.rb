class Video < ApplicationRecord
  has_one_attached :file
  has_many :screenshots, dependent: :destroy
  has_one :preview, -> { where(main: true) }, class_name: "Screenshot"
  has_many :video_people, dependent: :destroy
  has_many :people, through: :video_people
  has_many :video_tags, dependent: :destroy
  has_many :tags, through: :video_tags

  enum :status, unprocessed: 0, processing: 1, processed: 2

  default_scope { order(created_at: :asc) }
end
