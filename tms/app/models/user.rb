class User < ApplicationRecord
  has_many :tasks, :dependent => :destroy

  # For using encrypted password
  has_secure_password

  validates :name,
            presence: true,
            uniqueness: true
  validates :password,
            presence: true,
            length: { minimum: 6 },
            on: :create

  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def self.encrypt(token)
    Digest::SHA256.hexdigest(token.to_s)
  end
end
