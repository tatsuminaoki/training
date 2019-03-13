class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  validates :priority, presence: true
  validates :status, presence: true
  enum status: { 未着手: 0, 着手: 1, 完了: 2 }
  scope :get_by_name, ->(name) {
  where("name like ?", "%#{name}%")
  }
  scope :get_by_status, ->(status) {
  where(status: status)
  }

  def self.sort_and_search(params)
    tasks = Task.all
    if params[:name].present?
      tasks = tasks.where('name LIKE ?', "%#{params[:name]}%")
    end
    if params[:status].present?
      tasks = tasks.where(status: params[:status])
    end
    @tasks =
    case params[:sort]
    when 'endtime_DESC'
      tasks.order('endtime DESC')
    when 'endtime_ASC'
      tasks.order('endtime IS NULL, endtime ASC')
    else
      tasks.order('created_at DESC')
    end
  end
end