# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_many :tasks, dependent: :destroy
  validates :login_id, presence: true
  validates :password, presence: true, on: :create

  # prevent losing all admin on DB by limiting update and destroy.
  validate :update_the_last_admin_validator, on: :update
  before_destroy :destroy_the_last_admin_validator

  enum role: { admin: 'admin', common: 'common' }

  def update_the_last_admin_validator
    # updateの場合、 'admin' -> 'common'の場合のみvalidatorが必要
    if self.role == 'common'
      destroy_the_last_admin_validator
    end
  end

  def destroy_the_last_admin_validator
    # destroyの場合、'admin' のままで削除されるので、 `if self.role == 'common'`のチェックは必要ない
    if User.admin.count == 1 && User.admin.first.id == self.id
      errors.add(:role, :cannot_update_or_destroy_final_admin)
      throw :abort
    end
  end
end
