# frozen_string_literal: true

class User < ApplicationRecord
  has_one :user_credential, dependent: :destroy

  has_many :user_tokens, dependent: :destroy
  has_many :tasks, dependent: :destroy

  accepts_nested_attributes_for :user_credential

  enum role: { general: 1, management: 2 }, _prefix: true

  attr_accessor :email_confirmation

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  MINIMUM_NUMBER_OF_ADMINISTRATORS = 1

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validates :email, confirmation: true
  validates :email_confirmation, presence: true, on: :create

  validate :validates_last_admin_user, on: :update, if: -> { role_changed? }

  def validates_last_admin_user
    errors.add(:role, 'は、変更できません。変更する場合は、別の管理者ユーザーを用意してください。') if User.where(role: User.roles[:management]).count == MINIMUM_NUMBER_OF_ADMINISTRATORS
  end
end
