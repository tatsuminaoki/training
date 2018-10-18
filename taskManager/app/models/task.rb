class Task < ApplicationRecord
  belongs_to :user
  has_many :task_label, dependent: :destroy
  accepts_nested_attributes_for :task_label

  validates :task_name, presence: true
  validates :description, presence: true
  validates :user_id, presence: true
  validates :priority, presence: true
  validates :status, presence: true

  enum status: {
    waiting: 0, working: 1, completed: 2
  }
  enum priority: {
    low: 0, common: 1, high: 2
  }
end
