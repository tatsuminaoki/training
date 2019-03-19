# frozen_string_literal: true.
class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  validates :priority, presence: true
  validates :status, presence: true
  enum status: { waiting:0,  working:1, completed:2 }
  enum priority: { high:0, middle:1, low:2 }

  def self.sort_and_search(params)
    tasks = Task.all
    tasks = tasks.where('name LIKE ?', "%#{sanitize_sql_like(params[:name])}%") if params[:name].present?
    tasks = tasks.where(priority: params[:priority]) if params[:priority].present?
    tasks = tasks.where(status: params[:status]) if params[:status].present?
    case params[:sort]
    when 'endtime_DESC'
      tasks.order(endtime: :desc)
    when 'endtime_ASC'
      tasks.order(Arel.sql('endtime IS NULL, endtime ASC'))
    else
      tasks.order(created_at: :desc)
    end
  end
end
