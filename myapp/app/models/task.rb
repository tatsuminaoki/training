# frozen_string_literal: true

class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }

  enum status: %i[todo processing done]

  scope :name_like, ->(name) { where('name like ?', "%#{name}%") if name.present? }
  scope :status_is, ->(status) { where(status: status.to_i) if status.present? }

  def readable_status
    Task.human_attribute_name("status.#{self.status}")
  end

  def self.readable_statuses
    Task.statuses.map { |k, v| [Task.human_attribute_name("status.#{k}"), v] }.to_h
  end

  def readble_deadline
    self.deadline.presence || I18n.t(:no_deadline)
  end

  def self.find_with_conditions(params)
    sort_column, order = params[:sort_column].presence || 'created_at', params[:order].presence || 'desc'
    tasks = Task.name_like(params[:name]).status_is(params[:status]).order(sort_column.to_sym => order.to_sym).page params[:page]
    tasks
  end
end
