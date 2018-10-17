# frozen_string_literal: true

class Task < ApplicationRecord
  enum status: %i[yet do done]
  validates :title, presence: true, length: { maximum: 20 }
  validates :content, presence: true, length: { maximum: 255 }
  validates :status, presence: true

  belongs_to :user

  paginates_per 5

  def self.search_and_order(params, current_user)
    sort = params[:sort] || 'created_at'
    direction = params[:direction] || 'desc'
    search_title = params[:search_title]
    search_status = params[:search_status]
    tasks = self.page(params[:page])
    tasks = tasks.where(user_id: current_user.id)
    tasks = tasks.where('title LIKE ?', "%#{search_title}%") if search_title.present?
    tasks = tasks.where(status: search_status) if search_status.present?
    tasks.order("#{sort} #{direction}")
  end
end
