# frozen_string_literal: true

class User < ApplicationRecord
  has_many :tasks, dependent: :destroy

  devise :database_authenticatable, :registerable, :validatable
  enum auth_levels: [normal: 0, admin: 5]
  attribute :auth_level, default: 0

  # ユーザ名のチェック
  validates :name, presence: true, length: { maximum: 20 }

end
