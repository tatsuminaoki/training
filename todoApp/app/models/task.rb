class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 50 }

  def self.order_by_due_date_or_default(due_date_direction)
    if due_date_direction == 'DESC' || due_date_direction == 'ASC'
      order(due_date: due_date_direction.to_sym)
    else
      order(created_at: :desc)
    end
  end
end
