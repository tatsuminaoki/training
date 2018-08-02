# frozen_string_literal: true

class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  validates :email, presence: true, length: { maximum: 255 }, uniqueness: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :password, presence: true, length: { in: 6..30 }

  has_many :tasks, dependent: :destroy

  has_secure_password

  enum role: %i[general admin]

  before_destroy :check_last_admin_when_destroy
  validate :check_last_admin_when_update, if: :general?, on: :update
  attr_accessor :current_user

  private

  def check_last_admin_when_destroy
    return_error if admin? && User.admin.count == 1
  end

  def check_last_admin_when_update
    return_error if self == current_user && User.admin.count == 1
  end

  def return_error
    errors.add :base, I18n.t('errors.messages.at_least_one_admin')
    throw :abort
  end
end
