class User < ApplicationRecord
  has_many :tasks

  has_secure_password validations: true

  validates :email, presence: true, uniqueness: true
end
