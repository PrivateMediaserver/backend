class User < ApplicationRecord
  has_secure_password
  has_many :authentications, dependent: :destroy

  normalizes :email, with: ->(email) { email.downcase }
end
