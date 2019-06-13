# frozen_string_literal: true

class User < ApplicationRecord

  has_many :user_tokens
  has_one :user_credential

  attr_accessor :email_confirmation

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validates :email, confirmation: true
  validates :email_confirmation, presence: true, on: :create
end
