class Label < ApplicationRecord
  has_many :tasks, through: :task_to_labels
  has_many :task_to_labels
end
