class TaskLabel < ApplicationRecord
  validates :task_id, uniqueness: { scope: [:label_id] }

  belongs_to :task
  belongs_to :label
end
