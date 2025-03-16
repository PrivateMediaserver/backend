class User < ApplicationRecord
  has_secure_password
  has_many :authentications, dependent: :destroy
  has_many :collections, dependent: :destroy
  has_many :videos, through: :collections

  normalizes :email, with: ->(email) { email.downcase }
end
