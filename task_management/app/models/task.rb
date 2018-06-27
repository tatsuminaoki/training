class Task < ApplicationRecord
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
end
