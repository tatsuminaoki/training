class Task < ApplicationRecord
  validates :task_name, length: { minimum: 1 }
  validates :task_name, length: { maximum: 255 }
end
