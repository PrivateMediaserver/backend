class Collection < ApplicationRecord
  belongs_to :user
  has_many :videos, dependent: :destroy

  validates :name, presence: true
end
