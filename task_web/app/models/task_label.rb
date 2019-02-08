# frozen_string_literal: true

class TaskLabel < ApplicationRecord
  belongs_to :task
  belongs_to :label
  validates :task_id, allow_blank: true, numericality: { only_integer: true }
  validates :label_id, presence: true, numericality: { only_integer: true }
end
