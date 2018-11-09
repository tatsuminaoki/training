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

  def self.current
    Thread.current[:user]
  end

  def self.current=(user)
    Thread.current[:user] = user
  end

  private

  def set_default_role
    self.role ||= :normal
  end

  def update_role_valid?
    if User.current.present? && self.id == User.current.id
      if !self.admin?
        errors.add(:role, I18n.t('errors.messages.required_at_least_one_admin'))
        return false
      end
    elsif change_only_admin_user?(change_id: self.id) && !self.admin?
      errors.add(:role, I18n.t('errors.messages.required_at_least_one_admin'))
      return false
    end
    true
  end

  def delete_role_valid
    if User.current.present?
      return true if self.id != User.current.id
    else
      return true if User.admin.count > 1
      return true if self.id != User.admin.first.id
    end
    throw :abort
  end

  def change_only_admin_user?(change_id:)
    User.admin.count < 2 && change_id == User.admin.first.id
  end
end
