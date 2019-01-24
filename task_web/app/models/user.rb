# frozen_string_literal: true

class User < ApplicationRecord
  has_many :tasks, dependent: :destroy

  devise :database_authenticatable, :registerable, :validatable
  enum auth_levels: %i[normal admin].freeze
  attribute :auth_level, default: 0

  # ユーザ名のチェック
  validates :name, presence: true, length: { maximum: 20 }
  validates :auth_level, presence: true
end
