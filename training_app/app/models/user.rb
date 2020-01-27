# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  name            :string(255)      not null
#  password_digest :string(255)      not null
#  role            :integer          default("normal")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  has_secure_password

  has_many :tasks, dependent: :destroy

  validates :name, uniqueness: true, presence: true

  # 管理ユーザーから一般ユーザーに変更する場合、管理ユーザーは他に1人いないといけない
  validate proc {
    !check_if_can_be_admin_changed? && errors.add(:base, '')
  }, on: :update, if: -> { self.role_was == 'admin' && self.normal? }

  # 削除する場合、管理ユーザーは2名以上いないといけない
  before_destroy do
    unless check_if_can_be_admin_changed?
      errors.add(:base, '')
      throw(:abort)
    end
  end

  enum role: {
    normal: 0,
    admin: 1,
  }

  def check_if_can_be_admin_changed?
    self.class
      .where(role: :admin)
      .where.not(id: self.id)
      .count
      .positive?
  end
end
