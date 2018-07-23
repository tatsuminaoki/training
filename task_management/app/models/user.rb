class User < ApplicationRecord
  has_many :tasks, dependent: :delete_all
  validates :user_name, presence: true, length: {maximum: 255}
  validates :password, presence: true, on: :create
  validates :mail_address, length: {maximum: 255}, presence: true, uniqueness: true
  validate :correct_mail_address?
  
  has_secure_password 

  def correct_mail_address?
    if !mail_address.blank? && !(/\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i === mail_address)
      errors[:base] << '正しいメールアドレスを入力してください'
    end
  end
end
