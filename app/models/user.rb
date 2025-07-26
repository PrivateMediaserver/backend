class User < ApplicationRecord
  has_secure_password
  has_many :authentications, dependent: :destroy
  has_many :videos, dependent: :destroy
  has_many :tags, dependent: :destroy

  normalizes :email, with: -> { it.strip.downcase }
end
