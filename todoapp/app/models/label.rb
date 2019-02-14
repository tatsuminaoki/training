class Label < ApplicationRecord
  has_many :task_labels, dependent: :delete_all
  has_many :tasks, through: :task_labels
end
