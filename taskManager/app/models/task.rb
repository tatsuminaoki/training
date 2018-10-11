class Task < ApplicationRecord
  belongs_to :user
  has_many :task_label, dependent: :destroy
end
