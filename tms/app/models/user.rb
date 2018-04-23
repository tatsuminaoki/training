class User < ApplicationRecord
  has_many :tasks

  # For using encrypted password
  has_secure_password

  validates :name,
            presence: true,
            uniqueness: true
  validates :password,
            presence: true,
            length: { minimum: 6 }

  before_save :encrypt_password

  def encrypt_password
    self.password = encrypt(self.password)
  end

  # For using encyption
  SECURE = 'abcdefghijkABCDEFGHIJK0123456789'

  # Encryption method
  CIPHER = 'aes-256-cbc'

  # Encryption
  def encrypt(password)
    crypt = ActiveSupport::MessageEncryptor.new(SECURE, CIPHER)
    crypt.encrypt_and_sign(password)
  end
end
