class User < ApplicationRecord
  enum role: { General: 0, Admin: 1 }
  has_many :tasks, dependent: :delete_all
  has_one :user_session, dependent: :destroy

  has_secure_password validations: true
  validates :password, length: { minimum: 2 }, on: :create
  validates :password, length: { minimum: 2 }, allow_nil: true, on: :update

  validates :name,
    presence: true,
    length: { maximum: 32 }

  validates :email,
    presence: true,
    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
    uniqueness: { case_sensitive:  true },
    length: { maximum: 124 }

  validates :role,
    presence: true

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
