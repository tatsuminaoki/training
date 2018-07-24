class User < ApplicationRecord
  enum admin: {general: false, admin: true}
  has_many :tasks, dependent: :delete_all
  validates :user_name, presence: true, length: {maximum: 255}
  validates :password, presence: true, on: :create
  validates :mail_address, length: {maximum: 255}, presence: true, uniqueness: true
  validate :correct_mail_address?
  VALID_EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  has_secure_password 

  def correct_mail_address?
    unless mail_address.blank? || (VALID_EMAIL_REGEX === mail_address)
      errors[:base] << '正しいメールアドレスを入力してください'
    end
  end

  def count_tasks
    Task.where(user_id: self.id).size
  end
end
