# frozen_string_literal: true

class Task < ApplicationRecord
  enum status: { waiting: 1, work_in_progress: 2, completed: 3 }

  validates :name, presence: true, length: { maximum: 20 }

  scope :name_like, -> name { where('name like ?', "%#{name}%") if name.present? }
  scope :status, -> status { where(status: status) if status.present? }
end
