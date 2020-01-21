class User < ApplicationRecord
  has_many :tasks

  has_secure_password
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  validates :name, presence: true
end
