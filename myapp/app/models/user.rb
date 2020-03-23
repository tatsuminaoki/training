# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_many :user_projects, dependent: :destroy
  has_many :projects, through: :user_projects

  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def self.encrypt(token)
    Digest::SHA256.hexdigest(token.to_s)
  end
end
