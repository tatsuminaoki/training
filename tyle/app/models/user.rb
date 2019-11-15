# frozen_string_literal: true

class User < ApplicationRecord
  before_update :update_the_last_admin_validator
  before_destroy :destroy_the_last_admin_validator

  has_secure_password validations: true

  has_many :tasks, dependent: :destroy

  validates :name, presence: true
  validates :login_id, presence: true, uniqueness: { case_sensitive: true }
  validates :password, length: { minimum: 8 }, presence: true, on: :create
  validates :role, presence: true

  enum role: %i[general administrator]

  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def self.encrypt(token)
    Digest::SHA256.hexdigest(token.to_s)
  end

  def update_the_last_admin_validator
    return unless self.role == 'general' && User.where(role: 1).count == 1 && User.find_by(role: 1).id == self.id
    throw :abort
  end

  def destroy_the_last_admin_validator
    return unless User.where(role: 1).count == 1 && User.find_by(role: 1).id == self.id
    throw :abort
  end
end
