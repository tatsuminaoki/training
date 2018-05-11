class Label < ApplicationRecord
  has_many :tasks, through: :task_to_labels
  has_many :task_to_labels

  def self.labels_for_user(user_id)
    where(user_id: nil).or(where(user_id: user_id))
  end
end
