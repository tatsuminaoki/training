class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  validates :priority, presence: true
  validates :status, presence: true
  enum status: { 未着手: 0, 着手: 1, 完了: 2 }

  def self.sort_and_search(params)
    tasks = Task.all
      tasks = tasks.where('name LIKE ?', "%#{sanitize_sql_like(params[:name])}%") if params[:name].present?
      tasks = tasks.where(status: params[:status]) if params[:status].present?
    case params[:sort]
      when 'endtime_DESC'
        tasks.order(endtime: :desc)
      when 'endtime_ASC'
        tasks.order(Arel.sql('endtime IS NULL, endtime ASC'))
      else
        tasks.order(created_at: :desc)
    end
    # tasks = tasks.where('name LIKE ?', "%#{sanitize_sql_like(params[:name])}%") if params[:name].present?
    # tasks = tasks.where(status: params[:status]) if params[:status].present?
  end
  private

  # User.where(name: "hoge").order(create_at: :desc)
  # def name_search
  #   if params[:name].present?
  #     @tasks_name = tasks.where('name LIKE ?', "%#{sanitize_sql_like(params[:name])}%")
  #   else
  #     @tasks_name = Task.all
  #   end
  #   if params[:status].present?
  #     tasks_status = @tasks_name.where(status: params[:status])
  #   else
  #     tasks_status = @tasks_name
  #   end
  # end
end