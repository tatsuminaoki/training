class User < ApplicationRecord
  has_many :tasks

  has_secure_password

  validates :email, uniqueness: true
  validates :password_digest, length: { minimum: 8 }
end
