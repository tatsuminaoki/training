# frozen_string_literal: true

class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  validates :name, presence: true, length: { minimum: 4 }, uniqueness: true

  def self.digest(string)
    BCrypt::Password.create(string)
  end
end
