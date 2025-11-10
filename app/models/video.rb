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

  validates :name, presence: true

  generates_token_for :playlist, expires_in: 1.minute do
    updated_at
  end

  def self.random_unviewed_id_for_user(user)
    relation = user.videos.where(viewed: false)
    count = relation.count

    return nil if count.zero?

    relation.offset(rand(count)).limit(1).pick(:id)
  end
end
