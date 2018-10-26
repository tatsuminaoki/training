class Task < ApplicationRecord
  belongs_to :user
  has_many :task_label, dependent: :destroy
  accepts_nested_attributes_for :task_label

  enum status: {
    waiting: 0, working: 1, completed: 2
  }
  enum priority: {
    low: 0, common: 1, high: 2
  }

  validates :task_name,
            presence: true,
            length: { maximum: 255 }

  validates :description,
            presence: true,
            length: { maximum: 20_000 }

  validates :user_id, presence: true

  validates :priority,
            presence: true,
            inclusion: { in: Task.priorities.keys }

  validates :status,
            presence: true,
            inclusion: { in: Task.statuses.keys }

  # TODO: STEP10の課題で作ったもの
  default_scope -> { order(created_at: :desc) }
end
