# frozen_string_literal: true

class User < ApplicationRecord
  has_many :tasks

  validates :login_id,
            presence: true,
            length: { in: 1..100 },
            format: { with: /\A[a-z\d]{1,100}+\z/i, message: '100文字以内の英数字のみが使えます' }
  validates :password_digest,
            presence: true,
            length: { in: 8..100 },
            format: { with: /\A(?=.*?[a-z])(?=.*?[A-Z])(?=.*?\d)[a-zA-Z\d]{8,100}+\z/, message: '8〜100文字の半角英小文字大文字数字をそれぞれ1種類以上含む必要があります' }

  has_secure_password
end
