# frozen_string_literal: true

class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }

  enum status: %i[todo processing done]

  scope :name_like, ->(name) { where('name like ?', "%#{name}%") if name.present? }
  scope :status_is, ->(status) { where(status: status) if status.present? }
  scope :sort_by_column, ->(column, sort) { order((column.presence || 'created_at').to_sym => (sort.presence || 'desc').to_sym) }
  scope :labeled, ->(label_ids) { joins(:task_labels).where(task_labels: { label_id: label_ids }) if label_ids.present? }

  belongs_to :user
  has_many :task_labels, dependent: :delete_all
  has_many :labels, through: :task_labels

  def readable_status
    Task.human_attribute_name("status.#{self.status}")
  end

  def self.readable_statuses
    Task.statuses.map { |k, _| [Task.human_attribute_name("status.#{k}"), k] }.to_h
  end

  def readable_deadline
    self.deadline.present? ? self.deadline.strftime('%Y-%m-%d') : I18n.t(:no_deadline)
  end

  def self.find_with_params(params)
    labeled(params[:label_ids])
      .distinct
      .name_like(params[:name])
      .status_is(params[:status])
      .sort_by_column(params[:sort_column], params[:order]).page params[:page]
  end
end
