class Task < ApplicationRecord
  validates :task_name, presence: true
  validates :task_name, length: { maximum: 255 }
  validate :date_valid?

  def date_valid?
    begin
      !! Date.parse(due_date.to_s)
      true
    rescue
      if due_date_before_type_cast == ''
        true
      else
        errors.add(:due_date, I18n.t('errors.messages.failure'))
        false
      end
    end
  end
end
