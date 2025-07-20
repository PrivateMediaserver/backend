class User < ApplicationRecord
  has_secure_password
  has_many :authentications, dependent: :destroy
  has_many :collections, dependent: :destroy
  has_many :videos, through: :collections
  has_many :tags, dependent: :destroy

  normalizes :email, with: -> { it.strip.downcase }
end
