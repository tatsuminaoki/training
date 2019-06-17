class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validates :detail, presence: true, length: { maximum: 255 }
  validates :status, presence: true

  enum status: %i[todo doing done]

  belongs_to :user

  def self.search(params)
    tasks = Task.all
    tasks = tasks.where('title LIKE ?', "%#{sanitize_sql_like(params[:title])}%") if params[:title].present?
    tasks = tasks.where(status: params[:status]) if params[:status].present?
    tasks
  end
end
