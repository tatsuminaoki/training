class User < ApplicationRecord
  has_many :tasks

  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, length: { maximum: 255 }, uniqueness: true
  validates :password, presence: true, length: { maximum: 255 }
end
