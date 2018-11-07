class User < ApplicationRecord
  has_many :task, dependent: :destroy

  enum role: { normal: 0, admin: 10 }
  after_initialize :set_default_role, :if => :new_record?

  validates :mail,
            presence: true,
            uniqueness: { case_sensitive: false },
            email_format: {},
            length: { maximum: 255 }

  validates :user_name,
            presence: true,
            format: { with: /\A[\wa-zA-Z0-9ぁ-んァ-ン一-龥]+[\s　]?[\wa-zA-Z0-9ぁ-んァ-ン一-龥]+\z/ },
            length: { maximum: 255 }

  validates :role,
            presence: true,
            inclusion: { in: User.roles.keys }

  validate :update_role_valid?, on: :update
  before_destroy :delete_role_valid

  has_secure_password

  def set_default_role
    self.role ||= :normal
  end

  def update_role_valid?
    return true if User.admin.count > 1            # admin 2人以上
    return true if self.id != User.admin.first.id  # admin 1人、admin以外の変更であればOK
    return true if self.admin?                     # admin 1人、adminのroleがadminであればOK

    errors.add(:role, I18n.t('errors.messages.required_at_least_one_admin'))
    false
  end

  def delete_role_valid
    return true if User.admin.count > 1            # admin 2人以上
    return true if self.id != User.admin.first.id  # admin 1人、admin以外の変更であればOK
    throw :abort
  end
end
