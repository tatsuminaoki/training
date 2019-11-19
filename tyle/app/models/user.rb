# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_many :tasks, dependent: :destroy

  validates :name, presence: true
  validates :login_id, presence: true, uniqueness: { case_sensitive: true }
  validates :password, length: { minimum: 8 }, presence: true, on: :create
  validates :password, length: { minimum: 8 }, presence: true, on: :update
end
