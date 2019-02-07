class User < ApplicationRecord

  has_secure_password validations: true

  validates :name, presence: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,
            presence: true,
            uniqueness: true,
            format: { with: VALID_EMAIL_REGEX }

  has_many :tasks, dependent: :delete_all

  ROLE_GENERAL= 1
  ROLE_ADMIN = 2
  enum role: {
    general: ROLE_GENERAL,
    admin: ROLE_ADMIN
  }

  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def self.encrypt(token)
    Digest::SHA256.hexdigest(token.to_s)
  end
end
