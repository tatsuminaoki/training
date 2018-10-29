# frozen_string_literal: true

class User < ApplicationRecord
  enum role: %i[normal admin]

  validates :name, presence: true, length: { maximum: 30 }
  validates :email, presence: true, uniqueness: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, length: { maximum: 50 }
  validates :password, presence: true, length: { maximum: 12 }
  validates :role, presence: true

  has_many :tasks, dependent: :destroy
  has_secure_password

  before_destroy :check_last_admin_delete
  validate :check_last_admin_update, if: :normal?, on: :update
  attr_accessor :current_user

  private

  def check_last_admin_delete
    return_error if admin? && User.admin.count == 1
  end

  def check_last_admin_update
    return_error if self == current_user && User.admin.count == 1
  end

  def return_error
    errors.add :base, I18n.t('errors.messages.least_one_admin_destroy')
    throw :abort
  end
end
