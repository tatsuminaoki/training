# frozen_string_literal: true

class UserCredential < ApplicationRecord
  belongs_to :user
  has_secure_password
end
