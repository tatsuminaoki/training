# frozen_string_literal: true

class User < ApplicationRecord
  extend Enumerize
  has_many :tasks, dependent: :destroy

  has_secure_password
  enumerize :role, in: { general: 0, admin: 1 }, predicates: true, scope: true

  validates :name, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  validates :role, presence: true
  validate :keep_admin_user_role_for_last_one, on: :update
  before_destroy :keep_exist_admin_user

  def self.digest(string)
    BCrypt::Password.create(string)
  end

  private

  def keep_admin_user_role_for_last_one
    return unless general? && last_admin_users? && will_save_change_to_role?
    errors.add(:base, :at_least_one_admin)
    false
  end

  def keep_exist_admin_user
    return unless admin? && last_admin_users?
    errors.add(:base, :at_least_one_admin)
    throw(:abort)
  end

  def last_admin_users?
    User.with_role(:admin).where.not(id: id).empty?
  end
end
