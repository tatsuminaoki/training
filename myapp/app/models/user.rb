# frozen_string_literal: true

class User < ApplicationRecord
  has_many :tasks

  validates :login_id, presence: true
  validates :password, presence: true

  has_secure_password
end
