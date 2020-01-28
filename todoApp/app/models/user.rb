class User < ApplicationRecord
  ############################################################################################
  ## PeterGate Roles                                                                        ##
  ## The :user role is added by default and shouldn't be included in this list.             ##
  ## The :root_admin can access any page regardless of access settings. Use with caution!   ##
  ## The multiple option can be set to true if you need users to have multiple roles.       ##
  petergate(roles: [:admin], multiple: false)                                      ##
  ############################################################################################


  has_many :tasks, dependent: :destroy

  has_secure_password
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { case_sensitive: true }
  validates :name, presence: true
  validate :at_least_one_admin_should_be_exist, on: :update, if: -> { roles_changed? && self.role == :user }

  before_destroy :at_least_one_admin_should_be_exist

  private

  def at_least_one_admin_should_be_exist
    if User.where(roles: 'admin').count <= 1
      errors.add(:base, "At least one admin should be remain.")
      throw :abort
    end
  end
end
