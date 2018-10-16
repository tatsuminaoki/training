class Label < ApplicationRecord
  has_many :task_label

  validates :label_name, presence: true
  validates :label_name, uniqueness: true
end
