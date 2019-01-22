class Task < ApplicationRecord
  STATUS_NEW_TASK = 1
  STATUS_WORKING = 2
  STATUS_COMPLETED = 3
  enum status: {
    new_task: STATUS_NEW_TASK,
    working: STATUS_WORKING,
    completed: STATUS_COMPLETED
  }

  belongs_to :user

end
