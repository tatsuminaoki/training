class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 50 }

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
