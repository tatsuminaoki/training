# frozen_string_literal: true

class UserCredential < ApplicationRecord
  belongs_to :user
  has_secure_password

  validates :password, length: { minimum: 6 }, on: :create
  validates :password, length: { minimum: 6 }, allow_nil: true, on: :update
end
