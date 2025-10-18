class Person < ApplicationRecord
  belongs_to :user
  has_many :video_people, dependent: :destroy
  has_many :videos, through: :video_people
  has_one_attached :picture do |attachable|
    attachable.variant :webp, format: :webp
  end

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
