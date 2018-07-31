# frozen_string_literal: true

class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  validates :email, presence: true, length: { maximum: 255 }, uniqueness: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :password, presence: true, length: { in: 6..30 }

  has_many :tasks, dependent: :destroy

  has_secure_password

  enum role: %i[general admin]
end
