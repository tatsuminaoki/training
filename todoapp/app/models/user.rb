class User < ApplicationRecord
  has_secure_password validations: true

  validates :name, presence: true, length: { maximum: 12 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,
            presence: true,
            uniqueness: true,
            length: { maximum: 128 },
            format: { with: VALID_EMAIL_REGEX }

  has_many :tasks, dependent: :delete_all
  has_many :labels, dependent: :delete_all

  scope :with_task_count, lambda {
    left_outer_joins(:tasks)
      .select('users.*, count(tasks.id) as tasks_count')
      .group('users.id')
  }

  ROLE_GENERAL= 1
  ROLE_ADMIN = 2
  enum role: {
    general: ROLE_GENERAL,
    admin: ROLE_ADMIN
  }

  def admin?
    ROLE_ADMIN == role_before_type_cast
  end

  def myself?(user)
    id == user.id
  end

  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def self.encrypt(token)
    Digest::SHA256.hexdigest(token.to_s)
  end
end
