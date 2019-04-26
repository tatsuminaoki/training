class User < ApplicationRecord
  has_many :tasks
  has_many :labels

  has_secure_password
end
