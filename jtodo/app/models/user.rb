class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  validates :name,     presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 8 }, allow_nil: true
  has_secure_password
end
