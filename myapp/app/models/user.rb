# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_many :tasks, dependent: :destroy

  validates :account, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 4 }
  validates :password, length: { minimum: 4 }
end
