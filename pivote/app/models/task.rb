class Task < ApplicationRecord
  enum priority: {high: 10, middle: 20, low: 30}
  enum status: {waiting: 10, doing: 20, done: 30}
end
