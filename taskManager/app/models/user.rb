class User < ApplicationRecord
  has_many :task, dependent: :destroy

  validates :mail, presence: true
  validates :mail, uniqueness: true
  validates :user_name, presence: true
  validates :encrypted_password, presence: true
end
