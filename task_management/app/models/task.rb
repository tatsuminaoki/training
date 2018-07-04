class Task < ApplicationRecord
  enum status: [:todo, :doing, :done]
  enum priority: [:low, :middle, :high]

  validates :task_name, presence: true
  validates :task_name, length: { maximum: 255 }
  validate :due_date_valid?
  validates :status, inclusion: {in: Task.statuses.keys}
  validates :priority, inclusion: {in: Task.priorities.keys}
  
  def due_date_valid?
    return true if date_valid?(due_date)
    return true if due_date_before_type_cast.empty?

    errors.add(:due_date, I18n.t('errors.messages.failure'))
    false
  end

  def date_valid?(date)
    !! Date.parse(date.to_s) rescue false
  end

  def self.search(params)
    params[:searched_task_name] = '' if params[:searched_task_name].nil?
    tasks = if params[:searched_task_name].blank?
              Task.all
            else
              Task.where('task_name like ?', "%#{sanitize_sql_like(params[:searched_task_name])}%")
            end
    tasks = tasks.where(status: params[:statuses]) if params[:statuses].present?
    
    case params[:sort]
    when 'due_date_asc'
      tasks.order('due_date ASC')
    when 'due_date_desc'
      tasks.order('due_date DESC')
    when 'priority_asc'
      tasks.order('priority ASC')
    when 'priority_desc'
      tasks.order('priority DESC')
    else
      tasks.order('created_at DESC')
    end
  end
end
