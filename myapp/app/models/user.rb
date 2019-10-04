# frozen_string_literal: true

class User < ApplicationRecord
  has_many :tasks

  validates :login_id,
            presence: true,
            uniqueness: { case_sensitive: true },
            length: { in: 1..100 },
            format: { with: /\A[a-z\d]{1,100}+\z/i, message: '100文字以内の英数字のみが使えます' }

  has_secure_password validations: false
  validates :password,
            presence: true,
            length: { in: 8..100 },
            allow_nil: true,
            format: { with: /\A(?=.*?[a-z])(?=.*?[A-Z])(?=.*?\d)[a-zA-Z\d]{8,100}+\z/, message: '8〜100文字の半角英小文字大文字数字をそれぞれ1種類以上含む必要があります' }

  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def self.encrypt(token)
    Digest::SHA256.hexdigest(token.to_s)
  end
end
