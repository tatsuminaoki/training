# frozen_string_literal: true

class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 20 }
  validates :content, length: { maximum: 200 }

  enum status: %i[to_do doing done]
  enum priority: %i[low middle high]

  validates :status, inclusion: { in: self.statuses.keys }
  validates :priority, inclusion: { in: self.priorities.keys }

  # ページネーションの1ページ毎の表示数のデフォルトを変更
  paginates_per 10

  belongs_to :user

  def self.search_and_order(params, current_user)
    search_name = params[:search_name]
    search_status = params[:search_status]
    tasks = self.where(user_id: current_user.id)
    tasks = tasks.where('name LIKE ?', "%#{search_name}%") if search_name.present?
    tasks = tasks.where(status: search_status) if search_status.present?
    if params.key?(:sort_category)
      tasks.order(params[:sort_category].to_sym => params[:sort_direction].to_sym, created_at: :desc)
    else
      tasks.order(created_at: :desc)
    end
  end
end
