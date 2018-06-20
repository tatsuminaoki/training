class Task < ApplicationRecord
  validates :task_name, presence: true
  validates :task_name, length: { maximum: 255 }
end
