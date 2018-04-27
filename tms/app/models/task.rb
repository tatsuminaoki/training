class Task < ApplicationRecord
  belongs_to :user
  has_many :task_labels, dependent: :destroy
  has_many :labels, through: :task_labels

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

  def self.search(params, current_user_id, record_number)
    query = self
    query = query.order(due_date: order_option(params[:due_date_desc])) if params[:due_date_desc].present?
    query = query.order(priority: order_option(params[:priority_desc])) if params[:priority_desc].present?
    query = query.where(status: params[:status]) if params[:status].present?
    query = query.where('title like ?', '%'+params[:title]+'%') if params[:title].present?
    query = query.where(user_id: current_user_id)
    query = query.order(created_at: :desc)
    query = query.page(params[:page]).per(record_number)
  end

  def self.order_option(params)
    str = 'true'
    str.include?(params.to_s) ? :desc : :asc
  end

  def save_labels(tags)
    current_tags = self.labels.pluck(:name) unless self.labels.nil?
    old_tags = current_tags - tags
    new_tags = tags - current_tags

    old_tags.each do |old_name|
      self.labels.delete Label.find_by(name: old_name)
    end

    new_tags.each do |new_name|
      task_label = Label.find_or_create_by(name:new_name)
      self.labels << task_label
    end
  end
end
