class Task < ApplicationRecord
  enum status: { todo: 0, ongoing: 1, done: 2 }
  validates :title, presence: true, length: { maximum: 50 }
  validates :status, inclusion: { in: statuses }


  def self.search_result(title_keyword, current_status)
    search_by_title(title_keyword)
        .search_by_status(current_status)
  end

  def self.search_by_title(title_keyword)
    title_keyword.presence ? where("title Like ?", "%#{sanitize_sql_like(title_keyword)}%") : all
  end

  def self.search_by_status(current_status)
    # current_status.presence ? where("status = ?", current_status) : all
    current_status.presence ? where(status: current_status) : all
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
