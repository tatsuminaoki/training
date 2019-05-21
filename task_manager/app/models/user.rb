# frozen_string_literal: true

class User < ApplicationRecord
  extend Enumerize
  has_many :tasks, dependent: :destroy

  has_secure_password
  enumerize :role, in: { general: 0, administrator: 1 }, predicates: true

  validates :name, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  validates :role, presence: true

  def self.digest(string)
    BCrypt::Password.create(string)
  end
end
