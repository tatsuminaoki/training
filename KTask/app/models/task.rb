# frozen_string_literal: true

class Task < ApplicationRecord
  enum status: %i[yet do done]
  validates :title, presence: true, length: { maximum: 20 }
  validates :content, presence: true, length: { maximum: 255 }
  validates :status, presence: true

  def self.search_and_order(params)
    sort = params[:sort]
    sort = 'created_at' if sort.nil?
    direction = params[:direction]
    direction = 'desc' if direction.nil?
    search_title = params[:search_title]
    search_status = params[:search_status]
    tasks = Task.all
    tasks = tasks.where('title LIKE ?', "%#{search_title}%") if search_title.present?
    tasks = tasks.where(status: search_status) if search_status.present?
    tasks.order("#{sort} #{direction}")
  end
end
