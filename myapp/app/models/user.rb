# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :rememberable, :validatable,
         :authentication_keys => [:login_id]

  has_many :tasks

  validates :login_id,
            presence: true,
            uniqueness: { case_sensitive: true },
            length: { in: 1..100 },
            format: { with: /\A[a-z\d]{1,100}+\z/i, message: '100文字以内の英数字のみが使えます' }

  # No use email
  def email_required?
    false
  end

  def will_save_change_to_email?
    false
  end
end
