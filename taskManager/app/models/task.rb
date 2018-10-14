class Task < ApplicationRecord
  belongs_to :user
  has_many :task_label, dependent: :destroy
  accepts_nested_attributes_for :task_label

  STATUS_WAITING = 0
  STATUS_WORKING = 1
  STATUS_COMPLETED = 2

  PRIORITY_LOW = 0
  PRIORITY_COMMON = 1
  PRIORITY_HIGH = 2
end
