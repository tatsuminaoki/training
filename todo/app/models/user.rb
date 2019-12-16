# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  enum role: { general: 0, admin: 1 }

  has_many :tasks, dependent: :destroy

  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  validates :role, inclusion: { in: roles }

  before_destroy :not_to_delete_all_admin

  private

  def not_to_delete_all_admin
    return if general?
    return unless User.admin.count == 1
    errors.add :base, '最後の管理者のため削除できません'
    throw :abort
  end
end
