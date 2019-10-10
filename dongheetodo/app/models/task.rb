class Task < ApplicationRecord
  belongs_to :user
  has_many :task_labels, dependent: :delete_all
  has_many :labels, through: :task_labels

  enum status: {todo: 1, doing: 2, done: 3}
  enum priority: {low: 1, mid: 2, high: 3}
  enum sort_by: [:id, :duedate, :created_at]
  enum order: [:desc, :asc]

  validates :name, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 255 }
  validates :status, presence: true, inclusion: { in: Task.statuses.keys }
  validates :priority, presence: true, inclusion: { in: Task.priorities.keys }

  scope :search_with_name, ->(name) {
    if name.present?
      where('name LIKE ?', "%#{sanitize_sql_like(name)}%")
    end
  }
  scope :search_with_status, ->(status) {
    if status.present?
      where(status: status)
    end
  }
  scope :search_with_label, ->(label) {
    if label.present?
      where(labels: {id: label})
    end
  }
  scope :order_by, ->(target, order) {
    if target.present?
      if target === 'id'
        order(id: order)
      elsif target === 'duedate'
        order(duedate: order)
      elsif target === 'created_at'
        order(created_at: order)
      end
    else
      order(id: :desc)
    end
  }
  scope :search, ->(params) {
    search_with_name(params[:name])
      .search_with_status(params[:status])
      .search_with_label(params[:label])
      .order_by(params[:target], params[:order])
  }
  scope :own, ->(current_user) {
    where(user_id: current_user.id)
  }
end
