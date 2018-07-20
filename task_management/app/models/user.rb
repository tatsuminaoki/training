class User < ApplicationRecord
  has_many :tasks, dependent: :delete_all
  validates :user_name, presence: true
  validates :user_name, length: {maximum: 255}
  validates :password, presence: true, on: :create
  validates :mail_address, length: {maximum: 255}
  validates :mail_address, presence: true
  validates :mail_address, uniqueness: true
  validate :correct_mail_address?
  
  has_secure_password 

  def correct_mail_address?
    if !mail_address.blank? && !mail_address.include?('@')
      errors[:base] << '正しいメールアドレスを入力してください'
    end
  end
end
