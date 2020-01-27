# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  name            :string(255)      not null
#  password_digest :string(255)      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  has_secure_password

  has_many :tasks, dependent: :destroy

  validates :name, uniqueness: true, presence: true

  enum roles: {
    admin: 0,
    normal: 1,
  }
end
