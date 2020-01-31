class TaskLabel < ApplicationRecord
  belongs_to :task
  belongs_to :label

  scope :label_id, -> (selected_labels) { where(label_id: selected_labels) }
end
