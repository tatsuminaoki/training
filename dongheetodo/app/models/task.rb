class Task < ApplicationRecord
  belongs_to :user
  has_many :labels

  enum status: {todo: 1, doing: 2, done: 3}
  enum priority: {low: 1, mid: 2, high: 3}
end
