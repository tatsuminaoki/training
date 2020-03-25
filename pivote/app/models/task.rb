# frozen_string_literal: true

class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 30 }
  validates :description, length: { maximum: 1000 }

  belongs_to :user

  # 間に差込で追加したいという要望に応えられるよう、値を10の倍数としている
  enum priority: { low: 10, middle: 20, high: 30 }
  enum status: { done: 10, doing: 20, waiting: 30 }

  scope :search_with_priority, -> (priority) { where(priority: priority) if priority.present? }
  scope :search_with_status, -> (status) { where(status: status) if status.present? }
  scope :match_with_title, -> (title) { where(:title.to_s + ' LIKE ?', "%#{title}%") if title.present? }
  scope :sort_by_column, ->(column, sort) { order((column.presence || 'created_at').to_sym => (sort.presence || 'desc').to_sym) }

  def format_deadline
    I18n.l self.deadline, format: :date if self.deadline
  end
end
