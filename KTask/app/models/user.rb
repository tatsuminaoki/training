# frozen_string_literal: true

class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  validates :email, presence: true, uniqueness: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, length: { maximum: 50 }
  validates :password, presence: true, length: { maximum: 12 }

  has_many :tasks, dependent: :destroy
  has_secure_password
end
