# frozen_string_literal: true

class UserToken < ApplicationRecord
  belongs_to :user

  before_create :initialize_token
  before_create :initialize_expires_at

  TOKEN_EXPIRE_TERM = 2.days

  private

  def initialize_token
    self.token = SecureRandom.hex(32)
  end

  def initialize_expires_at
    self.expires_at = TOKEN_EXPIRE_TERM.since
  end
end
