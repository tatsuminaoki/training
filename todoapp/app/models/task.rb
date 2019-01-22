class Task < ApplicationRecord
  STATUS_NEW_TASK = 1
  STATUS_WORKING = 2
  STATUS_COMPLETED = 3

  belongs_to :user

end
