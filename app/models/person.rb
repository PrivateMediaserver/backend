class Person < ApplicationRecord
  belongs_to :user
  has_many :video_people, dependent: :destroy
  has_many :videos, through: :video_people

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
