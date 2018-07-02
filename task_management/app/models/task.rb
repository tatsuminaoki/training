class Task < ApplicationRecord
  enum status: [:todo, :doing, :done]

  validates :task_name, presence: true
  validates :task_name, length: { maximum: 255 }
  validate :due_date_valid?
  
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
    tasks = Task.where('task_name like ?', "%#{params[:search]}%")
    tasks = tasks.where(status: params[:statuses][:status]) if params[:statuses].present?
    
    case params[:sort]
    when 'due_date_asc'
      tasks.order('due_date ASC')
    when 'due_date_desc'
      tasks.order('due_date DESC')
    else
      tasks.order('created_at DESC')
    end
  end
end
