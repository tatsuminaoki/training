class Task < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :due_date, presence: true
  validates :priority,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 2
            }
  validates :status,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 2
            }
  validates :user_id,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than: 0
            }

  def self.search(params)
    query = self
    query = query.order(due_date: order_option(params[:due_date_desc])) if params[:due_date_desc].present?
    query = query.order(priority: order_option(params[:priority_desc])) if params[:priority_desc].present?
    query = query.where(status: params[:status]) if params[:status].present?
    query = query.where('title like ?', '%'+params[:title]+'%') if params[:title].present?
    query = query.order(created_at: :desc)
    query = query.page(params[:page]).per(5)
  end

  def self.order_option(params)
    str = 'true'
    str.include?(params.to_s) ? :desc : :asc
  end
end
