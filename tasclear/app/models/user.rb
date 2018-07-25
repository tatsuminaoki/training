# frozen_string_literal: true

class User < ApplicationRecord
  validates :name,
            presence: true,
            length: { maximum: 30 }
  validates :email,
            presence: true,
            uniqueness: true,
            format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
            length: { maximum: 255 }
  validates :password_digest,
            presence: true,
            length: { in: 6..30 }
end
