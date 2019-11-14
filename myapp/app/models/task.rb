# frozen_string_literal: true

class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }

  enum status: %i[todo processing done]

  def readable_status
    Task.human_attribute_name("status.#{self.status}")
  end

  def self.readable_statuses
    Task.statuses.map { |k, v| [Task.human_attribute_name("status.#{k}"), v] }.to_h
  end

  def readble_deadline
    self.deadline.present? ? self.deadline : I18n.t(:no_deadline)
  end

  def self.find_with_conditions(params)
    sort_column = params[:sort_column].present? ? params[:sort_column] : 'created_at'
    order = params[:order].present? ? params[:order] : 'desc'
    tasks = Task.order(sort_column.to_sym => order.to_sym)
    tasks = tasks.page params[:page]
    tasks = tasks.where('name like ?', "%#{params[:name]}%") if params[:name].present?
    tasks = tasks.where(status: params[:status].to_i) if params[:status].present?
    tasks
  end
end
