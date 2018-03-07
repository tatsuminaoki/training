class Task < ApplicationRecord
  validates :title, presence: true
  validates :deadline, presence: true
  validates :status, presence: true
  validates :priority, presence: true

  enum status: {not_start: "not_start", progress: "progress",  done: "done"}.freeze
  enum priority: {low: "low", normal: "normal", high: "high", quickly: "quickly", right_now: "right_now" }.freeze
end
