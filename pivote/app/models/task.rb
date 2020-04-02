# frozen_string_literal: true

class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 30 }
  validates :description, length: { maximum: 1000 }

  belongs_to :user
  has_many :task_labels, dependent: :destroy
  has_many :labels, :through => :task_labels
  accepts_nested_attributes_for :task_labels, reject_if: :reject_task_label, allow_destroy: true
  validate :task_label_be_unique

  # 間に差込で追加したいという要望に応えられるよう、値を10の倍数としている
  enum priority: { low: 10, middle: 20, high: 30 }
  enum status: { done: 10, doing: 20, waiting: 30 }

  scope :search_with_priority, -> (priority) { where(priority: priority) if priority.present? }
  scope :search_with_status, -> (status) { where(status: status) if status.present? }
  scope :search_with_label, -> (label) { joins(:task_labels).where(task_labels: { label_id: label }) if label.present? }
  scope :match_with_title, -> (title) { where(:title.to_s + ' LIKE ?', "%#{title}%") if title.present? }
  scope :sort_by_column, -> (column, sort) { order((column.presence || 'created_at').to_sym => (sort.presence || 'desc').to_sym) }

  def format_deadline
    I18n.l self.deadline, format: :date if self.deadline
  end

  private

  def task_label_be_unique
    task_labels.inject(Set.new) do |result, tl|
      if result.include?(tl.label_id)
        errors.add(:base, I18n.t('alert.duplicate_label'))
        return false
      end
      result.add(tl.label_id)
    end
    true
  end

  def reject_task_label(attributes)
    exists = attributes[:id].present?
    empty = attributes[:label_id].blank?
    attributes.merge!(_destroy: 1) if exists && empty
    !exists && empty
  end
end
