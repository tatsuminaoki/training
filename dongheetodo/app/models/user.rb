class User < ApplicationRecord
  has_many :tasks

  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true, length: { minimum: 8 }
end
