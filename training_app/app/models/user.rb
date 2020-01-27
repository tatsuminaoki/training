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
    !check_if_can_be_admin_changed? && errors.add(:base, I18n.t('errors.messages.check_admin_user_count'))
  }, on: :update, if: -> { self.role_was == 'admin' && self.normal? }

  # 削除する場合、管理ユーザーは2名以上いないといけない
  before_destroy do
    unless check_if_can_be_admin_changed?
      errors.add(:base, I18n.t('errors.messages.check_admin_user_count'))
      throw(:abort)
    end
  end

  enum role: {
    normal: 0,
    admin: 1,
  }

  # 管理ユーザーが２名以上いれば、変更可能
  def check_if_can_be_admin_changed?
    self.class.where(role: :admin).count >= 2
  end
end
