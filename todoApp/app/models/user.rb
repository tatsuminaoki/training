class User < ApplicationRecord
  has_many :tasks

  has_secure_password
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { case_sensitive: true }
  validates :name, presence: true
end
