class Tag < ApplicationRecord
  belongs_to :user
  has_many :video_tags, dependent: :destroy
  has_many :videos, through: :video_tags

  normalizes :name, with: -> { it.strip }

  validates :name, presence: true, uniqueness: { scope: :user_id, case_sensitive: false }
end
