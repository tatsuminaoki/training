class Task < ApplicationRecord
  belongs_to :user, touch: true, validate: true
  has_many :task_labels, dependent: :delete_all
  has_many :labels, through: :task_labels

  enum status: { todo: 0, ongoing: 1, done: 2 }
  validates :title, presence: true, length: { maximum: 50 }
  validates :status, inclusion: { in: statuses }
  validates_presence_of :user


  def self.search_result(title_keyword, current_status, selected_labels)
    search_by_title(title_keyword)
        .search_by_status(current_status)
        .search_by_labels(selected_labels)
  end

  def self.search_by_title(title_keyword)
    title_keyword.presence ? where("title Like ?", "%#{sanitize_sql_like(title_keyword)}%") : all
  end

  def self.search_by_status(current_status)
    current_status.presence ? where("status = ?", current_status) : all
  end

  def self.search_by_labels(selected_labels)
    if selected_labels
      task_ids = TaskLabel.where(label_id: selected_labels).pluck(:task_id)
      where(id: task_ids)
    else
      all
    end
  end

  def self.own_by(user_id)
    where(user_id: user_id)
  end

  def self.filter_by_ids_or_all(filtered_ids)
    filtered_ids.presence ? where(id: filtered_ids) : all
  end

  def self.order_by_due_date_or_default(due_date_direction)
    if due_date_direction == 'DESC' || due_date_direction == 'ASC'
      order("due_date #{due_date_direction}")
    else
      order(created_at: :desc)
    end
  end

end
