# frozen_string_literal: true

class Task < ApplicationRecord
  validates :name,
    presence: true,
    length: { maximum: 20 }
  validates :content, length: { maximum: 200 }

  enum status: %i[to_do doing done]
  enum priority: %i[low middle high]

  def self.search_and_order(params)
    search_name = params[:search_name]
    search_status = params[:search_status]
    tasks = self
    tasks = tasks.where('name LIKE ?', "%#{search_name}%") if search_name.present?
    tasks = tasks.where(status: search_status) if search_status.present?
    if params.key?(:sort_priority)
      tasks.order(priority: params[:sort_priority].to_sym, created_at: :desc)
    elsif params.key?(:sort_deadline)
      tasks.order(deadline: params[:sort_deadline].to_sym, created_at: :desc)
    else
      tasks.order(created_at: :desc)
    end
  end
end
