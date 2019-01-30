# frozen_string_literal: true

class User < ApplicationRecord
  has_many :tasks, dependent: :destroy

  devise :database_authenticatable, :registerable, :validatable
  enum auth_level: { normal: 0, admin: 5 }
  after_initialize :set_default_auth_level, if new_record?

  DEFAULT_ORDER_BY = :created_at
  DEFAULT_ORDER = :DESC
  ORDER_BY_VALUES = %w[created_at].freeze
  ORDER_VALUES = %w[ASC DESC].freeze

  # ユーザ名のチェック
  validates :name, presence: true, length: { maximum: 20 }
  # 権限レベルのチェック
  validates :auth_level, presence: true, inclusion: { in: self.auth_levels.keys }

  def set_default_auth_level
    self.auth_level ||= :normal
  end

  def self.search(order_by, order)
    user = self
    user = user.order(order_column(order_by) => sort_order(order))
    user
  end

  def self.sort_order(value)
    ORDER_VALUES.include?(value) ? value.upcase : DEFAULT_ORDER
  end

  def self.order_column(value)
    ORDER_BY_VALUES.include?(value) ? value : DEFAULT_ORDER_BY
  end
end
