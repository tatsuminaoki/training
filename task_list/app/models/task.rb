# frozen_string_literal: true.
class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  validates :priority, presence: true
  validates :status, presence: true

  enum status: { waiting:0,  working:1, completed:2 }
  enum priority: { high:0, middle:1, low:2 }

  has_many :task_labels
  has_many :labels, through: :task_labels
  accepts_nested_attributes_for :task_labels, allow_destroy: true

  belongs_to :user

  def self.sort_and_search(params)
    tasks = Task.all
    tasks = tasks.where('name LIKE ?', "%#{sanitize_sql_like(params[:name])}%") if params[:name].present?
    tasks = tasks.where(priority: params[:priority]) if params[:priority].present?
    tasks = tasks.where(status: params[:status]) if params[:status].present?
    if params[:label].present?
      # tasks = tasks.joins(:task_labels).where('task_labels.label_id = ?', params[:label])
      tasks = tasks.joins(:labels).where('labels.name LIKE ?', params[:label])
    end

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
