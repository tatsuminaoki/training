class User < ApplicationRecord
  has_many :tasks

  has_secure_password

  validates :name, presence: true, length: { maximum: 20 }
  validates :password, presence: true, length: { minimum: 6 }
end
