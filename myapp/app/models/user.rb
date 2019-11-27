class User < ApplicationRecord
  enum role: { general: 0, admin: 1 }
  has_many :tasks, dependent: :delete_all
  has_one :user_session, dependent: :destroy

  # before_update :remain_at_least_one_admin_user
  before_destroy :should_not_destroy_last_one_admin_user

  has_secure_password validations: true
  validates :password, length: { minimum: 2 }, on: :create
  validates :password, length: { minimum: 2 }, allow_nil: true, on: :update

  validates :name,
    presence: true,
    length: { maximum: 32 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,
    presence: true,
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive:  true },
    length: { maximum: 124 }

  validates :role,
    presence: true

  validate :validates_last_admin_user, on: :update, if: -> { role_changed? && self.general? }

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def should_not_destroy_last_one_admin_user
    if self.admin? && User.admin.count == 1
      throw :abort
    end
  end

  def validates_last_admin_user
    if User.admin.count == 1
      errors.add(:role, I18n.t('flash.update.change'))
    end
  end
end
