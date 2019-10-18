class Task < ApplicationRecord
  belongs_to :user
  enum priority: { low: 0, medium: 1, high: 2 }
  enum status: { 'waiting': 0, 'in progress': 1, done: 2 }
end
