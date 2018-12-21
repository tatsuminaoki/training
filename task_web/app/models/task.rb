# frozen_string_literal: true

class Task < ApplicationRecord
  enum priority: { low: 0, normal: 1, high: 2 }

  # タスク名のチェック
  validates :name,
            presence: true,
            length: { maximum: 20 }
  # 説明文のチェック
  validates :description,
            length: { maximum: 200 }
  # 優先順位のチェック
  validates :priority,
            presence: true,
            inclusion: { in: self.priorities.keys }
  # 期限のチェック
  validates :due_date,
            presence: true
  # ユーザIDのチェック
  validates :user_id,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than: 0,
            }

  def self.search(params)
    tasks = self
    @order_by = self.column_names.include?(params[:order_by]) ? params[:order_by] : 'created_at'
    @order = ('ASC'.casecmp?(params[:order]) ? 'ASC' : 'DESC')
    tasks.order(@order_by => @order)
  end
end
