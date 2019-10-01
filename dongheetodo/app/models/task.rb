class Task < ApplicationRecord
  belongs_to :user
  has_many :labels

  enum status: {todo: 1, doing: 2, done: 3}
  enum priority: {low: 1, mid: 2, high: 3}

  validates :name, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 255 }
  validates :status, presence: true, inclusion: { in: Task.statuses.keys }
  validates :priority, presence: true, inclusion: { in: Task.priorities.keys }

  scope :order_by_created_at, ->(order) { order(created_at: order) }
  scope :order_by_duedate, ->(order) { order(duedate: order) }
end
