# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user, optional: true

  validates :title,
            length: { in: 1..100 }
  validates :description,
            length: { maximum: 1000 }

  attribute :status, ActiveRecord::Type::Integer.new
  enum status: { waiting: 0, working: 1, completed: 2 }
  validates :status,
            inclusion: { in: Task.statuses.keys }

  def self.search_task(page, per, user_id = 0, status = nil)
    tasks = Task.page(page).per(per).includes(:user)
    tasks = tasks.where(status: status) unless status.nil?
    tasks = tasks.where(user_id: user_id) if user_id
    tasks
  end
end
