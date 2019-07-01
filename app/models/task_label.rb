# frozen_string_literal: true

class TaskLabel < ApplicationRecord
  belongs_to :task
  belongs_to :label

  scope :label_id, -> (label_ids) { where(label_id: label_ids) if label_ids.present? }
end
