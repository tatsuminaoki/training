# frozen_string_literal: true

class Task < ApplicationRecord
  # 未着手・着手中・完了
  enum status: { initial: 0, in_progress: 1, done: 2 }

  validates :name, presence: true
  validates :status, presence: true

  scope :name_like, -> (str) { where('`name` LIKE ?', "%#{str}%") }
end
