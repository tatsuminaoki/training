class User < ApplicationRecord
  has_many :tasks

  has_secure_password validations: true

  validates :name,
    presence: true,
    length: { maximum: 32 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,
    presence: true,
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive:  true },
    length: { maximum: 128 }

  validates :role,
    presence: true

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
