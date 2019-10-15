# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_many :tasks, dependent: :destroy
  validates :login_id, presence: true
  validates :password, presence: true, on: :create

  enum role: { admin: 'admin', common: 'common' }
end
