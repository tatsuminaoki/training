class Task < ApplicationRecord
  enum status: { todo: 0, ongoing: 1, done: 2 }
  validates :title, presence: true, length: { maximum: 50 }
  validates :status, inclusion: { in: status }

  def self.order_by_due_date(direction)
    if direction == 'due_date_desc'
      Task.order({ due_date: :desc })
    elsif direction == 'due_date_asc'
      Task.order({ due_date: :asc })
    else
      Task.order({ created_at: :desc })
    end
  end
end
