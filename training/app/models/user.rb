class User < ApplicationRecord
  has_secure_password
  has_many :tasks, dependent: :destroy

  VALID_EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  VALID_PASSWORD_REGEX = /\A[a-zA-Z0-9]+\z/

  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  validates :password, on: :create, presence: true, length: { in: 8..72 }, format: { with: VALID_PASSWORD_REGEX }
  validates :password, on: :update, presence: true, length: { in: 8..72 }, format: { with: VALID_PASSWORD_REGEX }, allow_blank: true

  enum role: { normal: 0, admin: 1 }
  validates :role, presence: true, inclusion: { in: User.roles.keys }
  validate :change_role_valid?, on: :update

  # 管理ユーザーが1ユーザーのみの状態で編集画面から権限を変更すると
  # 管理ユーザーが居ない状態に出来てしまう為、update時にバリデーションを行う
  private def change_role_valid?
    return true if User.admin.count > 1
    return true if self.admin?

    if User.admin.first.id == id
      errors.add(:role, I18n.t('errors.messages.role.require_least_one'))
      return false
    end

    true
  end
end
