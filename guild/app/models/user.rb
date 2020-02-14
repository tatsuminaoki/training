# frozen_string_literal: true

class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  has_one :login, dependent: :destroy
  enum authority: { member: 1, admin: 2 }
  validates :authority, presence: true, inclusion: { in: authorities.keys }
end
