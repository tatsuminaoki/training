# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, presence: true, length: { maximum: 30 }
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validates :password, presence: true, length: { minimum: 4 }

  validate :validate_admin_for_update, on: :update
  before_destroy :validate_admin_for_destroy

  has_many :tasks, dependent: :destroy

  private

  def validate_admin
    return if 1 < User.where(is_admin: true).count
    errors.add(:base, I18n.t('alert.admin_error'))
    throw :abort
  end

  def validate_admin_for_destroy
    return unless is_admin
    validate_admin
  end

  def validate_admin_for_update
    return if is_admin
    validate_admin
  end
end
