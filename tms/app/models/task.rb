class Task < ApplicationRecord
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
end
